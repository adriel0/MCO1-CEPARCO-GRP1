#include <stdio.h>
#include <stdlib.h>
#include <windows.h>
#include <time.h>

long long int nonavx(long long int count, long long int* A, long long int* b);
long long int xmm(long long int count, long long int* A, long long int* b);
long long int dotProduct(long long int count, long long int* A, long long int* B) {
	long long int sum = 0;
	for (long long int i = 0; i < count; i++)
	{
		sum += A[i] * B[i];
	}
	return sum;
}
int main() {
	clock_t start, end;
	LARGE_INTEGER StartingTime, EndingTime, ElapsedMicroseconds;
	LARGE_INTEGER Frequency;
	QueryPerformanceFrequency(&Frequency);

	double total_time;
	long long int count = 1<<15,ans;
	long long int * A_c, * B_c, * A_asm, * B_asm, * A_xmm, * B_xmm, * A_ymm, * B_ymm;
	A_c = (long long int*)malloc(count * sizeof(long long int));
	if (A_c == NULL)
		exit(1);
	B_c = (long long int*)malloc(count * sizeof(long long int));
	if (B_c == NULL)
		exit(1);
	A_asm = (long long int*)malloc(count * sizeof(long long int));
	if (A_asm == NULL)
		exit(1);
	B_asm = (long long int*)malloc(count * sizeof(long long int));
	if (B_asm == NULL)
		exit(1);
	A_xmm = (long long int*)malloc(count * sizeof(long long int));
	if (A_xmm == NULL)
		exit(1);
	B_xmm = (long long int*)malloc(count * sizeof(long long int));
	if (B_xmm == NULL)
		exit(1);
	A_ymm = (long long int*)malloc(count * sizeof(long long int));
	if (A_ymm == NULL)
		exit(1);
	B_ymm = (long long int*)malloc(count * sizeof(long long int));
	if (B_ymm == NULL)
		exit(1);
	for (long long int i = 0; i < count; i++)
	{
		A_c[i] = i + 1;
		B_c[i] = i + 1;
		A_asm[i] = i + 1;
		B_asm[i] = i + 1;
		A_xmm[i] = i + 1;
		B_xmm[i] = i + 1;
		A_ymm[i] = i + 1;
		B_ymm[i] = i + 1;
	}
	//nonavx
	start = clock();

	QueryPerformanceCounter(&StartingTime);
	ans=nonavx(count,A_asm,B_asm);

	QueryPerformanceCounter(&EndingTime);
	ElapsedMicroseconds.QuadPart = EndingTime.QuadPart - StartingTime.QuadPart;
	ElapsedMicroseconds.QuadPart *= 1000000;
	ElapsedMicroseconds.QuadPart /= Frequency.QuadPart;
	end = clock();
	total_time = ((double)(end - start)) * 1E3 / CLOCKS_PER_SEC;
	printf("%d\n", ans);
	printf("%lld\n", ElapsedMicroseconds);
	printf("%f\n", total_time);

	A_c = (long long int*)malloc(count * sizeof(long long int));
	if (A_c == NULL)
		exit(1);
	B_c = (long long int*)malloc(count * sizeof(long long int));
	if (B_c == NULL)
		exit(1);
	for (long long int i = 0; i < count; i++)
	{
		A_c[i] = i + 1;
		B_c[i] = i + 1;
	}
	//c
	start = clock();

	QueryPerformanceCounter(&StartingTime);
	ans = dotProduct(count, A_c, B_c);

	QueryPerformanceCounter(&EndingTime);
	ElapsedMicroseconds.QuadPart = EndingTime.QuadPart - StartingTime.QuadPart;
	ElapsedMicroseconds.QuadPart *= 1000000;
	ElapsedMicroseconds.QuadPart /= Frequency.QuadPart;
	end = clock();
	total_time = ((double)(end - start)) * 1E3 / CLOCKS_PER_SEC;
	printf("%d\n", ans);
	printf("%lld\n", ElapsedMicroseconds);
	printf("%f\n", total_time);



	A_xmm = (long long int*)malloc(count * sizeof(long long int));
	if (A_xmm == NULL)
		exit(1);
	B_xmm = (long long int*)malloc(count * sizeof(long long int));
	if (B_xmm == NULL)
		exit(1);
	for (long long int i = 0; i < count; i++)
	{
		A_xmm[i] = i + 1;
		B_xmm[i] = i + 1;
	}

	//xmm
	start = clock();

	QueryPerformanceCounter(&StartingTime);
	ans = xmm(count, A_xmm, B_xmm);
	end = clock();
	QueryPerformanceCounter(&EndingTime);
	ElapsedMicroseconds.QuadPart = EndingTime.QuadPart - StartingTime.QuadPart;
	ElapsedMicroseconds.QuadPart *= 1000000;
	ElapsedMicroseconds.QuadPart /= Frequency.QuadPart;
	
	total_time = ((double)(end - start)) * 1E3 / CLOCKS_PER_SEC;
	printf("%d\n", ans);
	printf("%lld\n", ElapsedMicroseconds);
	printf("%f\n", total_time);


	/*
	free(A_c);
	free(B_c);
	free(A_asm);
	free(B_asm);
	free(A_xmm);
	free(B_xmm);
	free(A_ymm);
	free(B_ymm);*/
	return 0;
}


