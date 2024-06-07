i.) screenshot of the program output with execution time for all cases

ii.) comparative table of execution time as well as analysis of the performance of different kernels (how many times faster, why is it faster, etc.), including screenshots of the program output with correctness checking for all kernels

For n = 2^20:

Debug:



Release:

![image](https://github.com/adriel0/MCO1-CEPARCO-GRP1/assets/115350015/585dea95-1950-46f7-b84e-277ab531a123)

|       | C | x86-64| SIMD XMM | SIMD YMM |
| :-----: | :-------: | :-------: | :-------: | :-------: |
| Average Execution Time (Debug)|    0    |    0    |    0    |    0    |
| Average Execution Time (Release)|    1.092933ms    |    1.565833ms    |    0.961800ms    |    0.333333ms    |

For n = 2^26:

Debug:



Release:

![image](https://github.com/adriel0/MCO1-CEPARCO-GRP1/assets/115350015/ea7f3b25-59f2-47fd-9f43-e98740f58780)


|       | C | x86-64| SIMD XMM | SIMD YMM |
| :-----: | :-------: | :-------: | :-------: | :-------: |
| Average Execution Time (Debug)|    0    |    0    |    0    |    0    |
| Average Execution Time (Release)|    68.608000ms    |    92.775800ms    |    71.739300ms    |    65.100000ms    |

For n = 2^30:

Debug:



Release:

![image](https://github.com/adriel0/MCO1-CEPARCO-GRP1/assets/115350015/b8e3f998-afd9-4b72-b105-e571c8142be1)

|       | C | x86-64| SIMD XMM | SIMD YMM |
| :-----: | :-------: | :-------: | :-------: | :-------: |
| Average Execution Time (Debug)|    0    |    0    |    0    |    0    |
| Average Execution Time (Release)|    1,283.116767ms    |    1,696.943567ms    |    1,376.273100ms    |    1,268.833333ms    |

**Performance (Debug)**

Mention how the SIMD contributes to the runtime? 

**Performance (Release)**

From the resulting data for release mode, we can see that asm (x86-64) is the slowest among the 4 kernels for all values of n that we tried. This is because it does not have any form of optimization, and it executes a lot of instructions compared to the other kernels.  


vii.) Discuss the problems encountered and solutions made, unique methodology used, AHA moments, etc.

While running the simulation, one problem we encountered was the release mode reaching out of bounds in its memory access for the YMM registers. We had an AHA moment that we were supposed to push and pop the values into a stack, which solved the issue. Another problem we had was that the initial program was not running on the machines of 3 of our group members. We found out later that one of the instructions we used was for AVX512, and most of our machines did not have it, so we fixed it by changing the vmullq instruction with vmuludq.

In terms of the unique methodology used, we used the pshufd instruction in order to get the sum of the products. To explain how we used the pshufd instruction, we start with its usage in the xmm portion. We started by using the vpmuludq instruction to multiply the data in xmm1 and xmm2 and store the products in xmm1. At this point, we simply wanted to get the sum of the values (products) stored in xmm1, but there is no straightforward instruction to do so. Instead, we used the pshufd instruction on xmm1 with order "01_00_11_10" and stored the result in xmm2. Essentially, this shuffle instruction will align the products so that adding xmm1 and xmm2 will result in the correct sum.

The same methodology was applied in the ymm portion wherein we used the vpshufd instruction with order "01_00_11_10" to rearrange the products so that they could be added. However, since ymm can hold 4 64-bit integers, we had to store partial sums in xmm11 and xmm2. Then, we had to add the partial sums in xmm11 and xmm2 in order to obtain the final sum which is the dot product.
