i.) screenshot of the program output with execution time for all cases

ii.) comparative table of execution time as well as analysis of the performance of different kernels (how many times faster, why is it faster, etc.)

|       | C | x86-64| SIMD XMM | SIMD YMM |
| :-----: | :-------: | :-------: | :-------: | :-------: |
| Average Execution Time (Debug)|    0    |    0    |    0    |    0    |
| Average Execution Time (Release)|    0    |    0    |    0    |    0    |
| Performance (Debug) |
| Performance (Release) |




iii.) screenshot of the program output with correctness check (C)

iv.) screenshot of the program output, including correctness check (x86-64)

v.) screenshot of the program output, including correctness check (SIMD XMM register)

vi.) screenshot of the program output, including correctness check (SIMD, YMM register)

vii.) Discuss the problems encountered and solutions made, unique methodology used, AHA moments, etc.

While running the simulation, one problem we encountered was the release mode reaching out of bounds in its memory access for the YMM registers. We had an AHA moment that we were supposed to push and pop the values into a stack, which solved the issue.

In terms of the unique methodology used, we ***INSERT EXPLANATION FOR SHUFFLING FOR YMM***
