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
	long long int count = 5,ans;
	long long int* A = malloc(count * sizeof(long long int));
	long long int* B = malloc(count * sizeof(long long int));
	for (long long int i = 0; i < count; i++)
	{
		A[i] = i + 1;
		B[i] = i + 1;
	}
	//nonavx
	start = clock();

	QueryPerformanceCounter(&StartingTime);
	ans=nonavx(count,A,B);

	QueryPerformanceCounter(&EndingTime);
	ElapsedMicroseconds.QuadPart = EndingTime.QuadPart - StartingTime.QuadPart;
	ElapsedMicroseconds.QuadPart *= 1000000;
	ElapsedMicroseconds.QuadPart /= Frequency.QuadPart;
	end = clock();
	total_time = ((double)(end - start)) * 1E3 / CLOCKS_PER_SEC;
	printf("%d\n", ans);
	printf("%lld\n", ElapsedMicroseconds);
	printf("%f\n", total_time);

	//c
	start = clock();

	QueryPerformanceCounter(&StartingTime);
	ans = dotProduct(count, A, B);

	QueryPerformanceCounter(&EndingTime);
	ElapsedMicroseconds.QuadPart = EndingTime.QuadPart - StartingTime.QuadPart;
	ElapsedMicroseconds.QuadPart *= 1000000;
	ElapsedMicroseconds.QuadPart /= Frequency.QuadPart;
	end = clock();
	total_time = ((double)(end - start)) * 1E3 / CLOCKS_PER_SEC;
	printf("%d\n", ans);
	printf("%lld\n", ElapsedMicroseconds);
	printf("%f\n", total_time);

	//xmm
	start = clock();

	QueryPerformanceCounter(&StartingTime);
	ans = xmm(count, A, B);

	QueryPerformanceCounter(&EndingTime);
	ElapsedMicroseconds.QuadPart = EndingTime.QuadPart - StartingTime.QuadPart;
	ElapsedMicroseconds.QuadPart *= 1000000;
	ElapsedMicroseconds.QuadPart /= Frequency.QuadPart;
	end = clock();
	total_time = ((double)(end - start)) * 1E3 / CLOCKS_PER_SEC;
	printf("%d\n", ans);
	printf("%lld\n", ElapsedMicroseconds);
	printf("%f\n", total_time);
	return 0;
}


