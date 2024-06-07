CEPARCO S11 Group 1

CHAN, Ethan Lester  
DOLON, John Michael  
LU, Andre Giancarlo  
TENG, Adriel Shanlley  

Given specs: Dot product of 64-bit integers

i.) comparative table of execution time as well as analysis of the performance of different kernels (how many times faster, why is it faster, etc.), including screenshots of the program output with correctness checking and execution time for all kernels

For n = 2^20:

Debug:

![image](https://github.com/adriel0/MCO1-CEPARCO-GRP1/assets/115350015/c9fb541e-2245-4153-8467-42f6dfcb48e5)

Release:

![image](https://github.com/adriel0/MCO1-CEPARCO-GRP1/assets/115350015/7fb27147-20f4-408c-a226-78434466dbdf)

|       | C | x86-64| SIMD XMM | SIMD YMM |
| :-----: | :-------: | :-------: | :-------: | :-------: |
| Average Execution Time (Debug)|    2.917933ms    |    1.407000ms    |    1.065233ms    |    0.533333ms    |
| Average Execution Time (Release)|    1.066000ms    |    1.760267ms    |    1.393533ms    |    0.166667ms    |

For n = 2^26:

Debug:

![image](https://github.com/adriel0/MCO1-CEPARCO-GRP1/assets/115350015/332d5ee9-0cbf-4011-ba45-f7896d52c68f)

Release:

![image](https://github.com/adriel0/MCO1-CEPARCO-GRP1/assets/115350015/dafea09f-e7ea-4c88-8451-27cd58e8267a)

|       | C | x86-64| SIMD XMM | SIMD YMM |
| :-----: | :-------: | :-------: | :-------: | :-------: |
| Average Execution Time (Debug)|    170.628267ms    |    90.260667ms    |    71.699733ms    |    67.766667ms    |
| Average Execution Time (Release)|    68.361533ms    |    88.622200ms    |    72.204433ms    |    64.600000ms    |

For n = 2^30:

Debug:

![image](https://github.com/adriel0/MCO1-CEPARCO-GRP1/assets/115350015/cf27a500-38c4-4b05-b378-e629dd91cb85)

Release:

![image](https://github.com/adriel0/MCO1-CEPARCO-GRP1/assets/115350015/8ba7cf74-fc2a-4e42-87e5-5c8f35d36702)

|       | C | x86-64| SIMD XMM | SIMD YMM |
| :-----: | :-------: | :-------: | :-------: | :-------: |
| Average Execution Time (Debug)|    2,886.756000ms    |    1,496.579067ms    |    1,172.443033ms    |    1,114.700000ms    |
| Average Execution Time (Release)|    1,124.485600ms    |    1,496.836267ms    |    1,174.047900ms    |    1,056.433333ms    |

**Overall Performance (Debug)**

From the resulting data from testing in Debug mode, we observed that C is by far the slowest of the 4 kernels, followed by ASM (x86-64), then SIMD (xmm registers), and then SIMD (ymm registers) being the fastest.

C in debug mode is very, very slow. This is because of the lack of optimization, as in debug mode, most optimizations are removed to preserve the exact structure of the source code, making it much easier for the program to debug. With this, C in debug mode is not made for speed. Rather, it is used to check that the code runs properly.

Performing much better than C in debug mode is ASM (x86-64). In general, Assembly code is supposed to enable the programmer to write optimized code that can outperform high-level language code. However, registers in this kernel can only hold 1 64-bit integer, and with the fact that the program needs to execute a lot of instructions, it performs the second slowest out of the 4 kernels.

Following ASM (x86-64), we have SIMD (xmm registers). This kernel shows that having registers that can store 2 64-bit integers at once is faster than having registers that can only store 1 64-bit integer, allowing data parallelism. 

However, what's better than being able to store 2 64-bit integers in 1 register? Being able to store 4 64-bit integers in 1 register! With SIMD (ymm registers) having 256-bit registers in its disposal, not only it is an Assembly language, it can also perform faster data parallelism than SIMD (xmm registers), outpacing the other 3 kernels by a good margin. 

**Overall Performance (Release)**

From the resulting data from testing in Release mode, we observed that ASM (x86-64) is the slowest among the 4 kernels, followed by SIMD (xmm registers), then C, and then SIMD (ymm registers) being the fastest.

ASM (x86-64) is the slowest for all values of n that we tried. This is because it does not have any form of optimization, and it executes a lot of instructions compared to the other kernels.

Next is SIMD (xmm registers). Although being faster than ASM (x86-64) due to each register being able to store 2 64-bit integers at once, and having the ability to perform data parallelism, the program still executes a lot of instructions, slowing the kernel down.

Next is C, showing that C in release mode is much faster than C in debug mode. This is because in release mode, running C programs is much more optimized, due to the kernel not caring about debugging. This makes it faster than ASM (x86-64) and SIMD (xmm registers). 

However, C in release mode still falls short to SIMD (ymm registers). Having the capability of using registers that can hold 4 64-bit integers helps with faster data parallelism. This also helps with CPU Resource Management, allowing the CPU to handle more data per machine cycle.


ii.) Discuss the problems encountered and solutions made, unique methodology used, AHA moments, etc.

While running the simulation, one problem we encountered was the release mode reaching out of bounds in its memory access for the YMM registers. We had an AHA moment that we were supposed to push and pop the values into a stack, which solved the issue. Another problem we had was that the initial program was not running on the machines of 3 of our group members. We found out later that one of the instructions we used was for AVX512, and most of our machines did not have it, so we fixed it by changing the vmullq instruction with vmuludq.

In terms of the unique methodology used, we handled the boundary checking by first getting the number of elements of the input array and performing a modulo operation on it using the number of elements of the respective register. For xmm, this was done through by performing an AND instruction between the number of elements in the array with 1b. The idea is that if the LSB is 1, it means that there will be an extra element remaining. The same approach was used for ymm but instead of ANDing with 1, we ANDed the number of elements of the array with 11b, so if the two least significant bits are not 00b, it means there will be at least 1 extra element remaining. Next, we simply run our loop by shifting the loop count to the right by 1 for xmm, and 2 for ymm since we want to shift by 2 elements and 4 elements respectively. Then, now that we know if there are extra elements based on the resulting value after the AND operation, we can determine how many extra iterations of the loop will need to be performed, and we can run a special set of instructions modified to ignore garbage values.

Another unique methodology we used is the pshufd instruction in order to get the sum of the products. To explain how we used the pshufd instruction, we start with its usage in the xmm portion. We started by using the vpmuludq instruction to multiply the data in xmm1 and xmm2 and store the products in xmm1. At this point, we simply wanted to get the sum of the values (products) stored in xmm1, but there is no straightforward instruction to do so. Instead, we used the pshufd instruction on xmm1 with order "01_00_11_10" and stored the result in xmm2. Essentially, this shuffle instruction will align the products so that adding xmm1 and xmm2 will result in the correct sum. The same methodology was applied in the ymm portion wherein we used the vpshufd instruction with order "01_00_11_10" to rearrange the products so that they could be added. However, since ymm can hold 4 64-bit integers, we had to store partial sums in xmm11 and xmm2. Then, we had to add the partial sums in xmm11 and xmm2 in order to obtain the final sum which is the dot product.
