i.) screenshot of the program output with execution time for all cases

ii.) comparative table of execution time as well as analysis of the performance of different kernels (how many times faster, why is it faster, etc.)

For n = 2^20:
|       | C | x86-64| SIMD XMM | SIMD YMM |
| :-----: | :-------: | :-------: | :-------: | :-------: |
| Average Execution Time (Debug)|    0    |    0    |    0    |    0    |
| Average Execution Time (Release)|    0    |    0    |    0    |    0    |

**Performance (Debug)**
**Performance (Release)**

Mention how the SIMD contributes to the runtime? 

**Performance (Release)**




iii.) screenshot of the program output with correctness check (C)

iv.) screenshot of the program output, including correctness check (x86-64)

v.) screenshot of the program output, including correctness check (SIMD XMM register)

vi.) screenshot of the program output, including correctness check (SIMD, YMM register)

vii.) Discuss the problems encountered and solutions made, unique methodology used, AHA moments, etc.

While running the simulation, one problem we encountered was the release mode reaching out of bounds in its memory access for the YMM registers. We had an AHA moment that we were supposed to push and pop the values into a stack, which solved the issue.

In terms of the unique methodology used, we used the pshufd instruction in order to get the sum of the products. To explain how we used the pshufd instruction, we start with its usage in the xmm portion. We started by using the vpmuludq instruction to multiply the data in xmm1 and xmm2 and store the products in xmm1. At this point, we simply wanted to get the sum of the values (products) stored in xmm1, but there is no straightforward instruction to do so. Instead, we used the pshufd instruction on xmm1 with order "01_00_11_10" and stored the result in xmm2. Essentially, this shuffle instruction will align the products so that adding xmm1 and xmm2 will result in the correct sum.

The same methodology was applied in the ymm portion wherein we used the vpshufd instruction with order "01_00_11_10" to rearrange the products so that they could be added. However, since ymm can hold 4 64-bit integers, we had to store partial sums in xmm11 and xmm2. Then, we had to add the partial sums in xmm11 and xmm2 in order to obtain the final sum which is the dot product.
