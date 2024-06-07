#include <stdio.h>
#include <stdlib.h>
#include <windows.h>
#include <time.h>

long long int nonavx(long long int count, long long int* A, long long int* b);
long long int xmm(long long int count, long long int* A, long long int* b);
long long int ymm(long long int count, long long int* A, long long int* b);
long long int dotProduct(long long int count, long long int* A, long long int* B) {
	long long int sum = 0;
	for (long long int i = 0; i < count; i++)
	{
		sum += A[i] * B[i];
	}
	return sum;
}
int main() {
	LARGE_INTEGER StartingTime, EndingTime, ElapsedMicroseconds;
	LARGE_INTEGER Frequency;
	QueryPerformanceFrequency(&Frequency);
	int numofruns = 30, initNumofRuns = 5;
	double total_time, sum_time, ave_time;
	int accuracy;
	long long int count = 1<<20, ans;
	long long int* A, * B;
	A = (long long int*)malloc(count * sizeof(long long int));
	if (A== NULL)
		exit(1);
	B = (long long int*)malloc(count * sizeof(long long int));
	if (B== NULL)
		exit(1);
	srand(time(0));
	for (long long int i = 0; i < count; i++)
	{
		A[i] = rand();
		B[i] = rand();
	}

	printf("Number of elements: %lld\n\n", count);
	const long long int Ref_ans = dotProduct(count, A, B);
	printf("Dot product reference:\t %lld\n\n", Ref_ans);
	
	//c
	sum_time = 0;
	accuracy = 0;
	for (int i = 0; i < initNumofRuns; i++)
	{
		ans = dotProduct(count, A, B);
		if (ans != Ref_ans)
		{
			accuracy++;
		}
	}

	for (int i = 0; i < numofruns; i++)
	{
		QueryPerformanceCounter(&StartingTime);
		ans = dotProduct(count, A, B);
		QueryPerformanceCounter(&EndingTime);
		total_time = ((double)((EndingTime.QuadPart - StartingTime.QuadPart) * 1000000 / Frequency.QuadPart)) / 1000;
		if (ans != Ref_ans)
		{
			accuracy++;
		}
		//printf("%lld\n", ans);
		//printf("%f\n", total_time);
		sum_time += total_time;
	}

	ave_time = sum_time / numofruns;
	//printf("Accuracy in C: %f\n", accuracy);
	printf("Dot product in C:        %lld\n", ans);
	printf("Number of misses in C: %d\n", accuracy);
	printf("Average time of %d runs in in C: %f ms\n\n", numofruns, ave_time);
	
	
	//nonavx
	sum_time = 0;
	accuracy = 0;
	for (int i = 0; i < initNumofRuns; i++)
	{
		ans = nonavx(count, A, B);
		if (ans != Ref_ans)
		{
			accuracy++;
		}
	}
	for (int i = 0; i < numofruns; i++)
	{
		QueryPerformanceCounter(&StartingTime);
		ans = nonavx(count, A, B);
		QueryPerformanceCounter(&EndingTime);
		total_time = ((double)((EndingTime.QuadPart - StartingTime.QuadPart) * 1000000 / Frequency.QuadPart)) / 1000;
		if (ans != Ref_ans)
		{
			accuracy++;
		}
		//printf("%lld\n", ans);
		//printf("%f\n", total_time);
		sum_time += total_time;
	}
	
	ave_time = sum_time / numofruns;
	printf("Dot product in asm:      %lld\n", ans);
	printf("Number of misses in asm: %d\n", accuracy);
	printf("Average time of %d runs in asm: %f ms\n\n",numofruns , ave_time);


	//xmm
	sum_time = 0;
	accuracy = 0;
	for (int i = 0; i < initNumofRuns; i++)
	{
		ans = xmm(count, A, B);
		if (ans != Ref_ans)
		{
			accuracy++;
		}
	}
	for (int i = 0; i < numofruns; i++)
	{
		QueryPerformanceCounter(&StartingTime);
		ans = xmm(count, A, B);
		QueryPerformanceCounter(&EndingTime);
		total_time = ((double)((EndingTime.QuadPart - StartingTime.QuadPart) * 1000000 / Frequency.QuadPart)) / 1000;
		if (ans != Ref_ans)
		{
			accuracy++;
			printf("%lld\n", ans);
		}
		//printf("%lld\n", ans);
		//printf("%f\n", total_time);
		sum_time += total_time;
	}

	ave_time = sum_time / (float) numofruns;
	printf("Dot product in xmm:      %lld\n", ans);
	printf("Number of misses in xmm: %d\n", accuracy);
	printf("Average time of %d runs in xmm: %f ms\n\n", numofruns, ave_time);
	/**/
	//ymm
	sum_time = 0;
	accuracy = 0;
	for (int i = 0; i < initNumofRuns; i++)
	{
		ans = ymm(count, A, B);
		if (ans != Ref_ans)
		{
			accuracy++;
			printf("%lld\n", ans);
		}
	}
	for (int i = 0; i < numofruns; i++)
	{
		QueryPerformanceCounter(&StartingTime);
		ans = ymm(count, A, B);
		QueryPerformanceCounter(&EndingTime);
		total_time = ((double)((EndingTime.QuadPart - StartingTime.QuadPart) * 1000 / Frequency.QuadPart));

		//printf("temp time in ymm: %f\n", temp);
		//total_time =  temp/ 1000.0;

		//printf("total time in ymm: %f\n", total_time);
		if (ans != Ref_ans)
		{
			accuracy++;
		}
		//printf("%lld\n", ans);
		//printf("%f\n", total_time);
		sum_time += total_time;
		//("counting time in ymm: %f\n", sum_time);
	}

	//printf("sum time in ymm: %f\n", sum_time);
	//printf("run time in ymm: %f\n", numofruns);
	ave_time = (double)sum_time/numofruns;
	printf("Dot product in ymm:      %lld\n", ans);
	printf("Number of misses in ymm: %d\n", accuracy);
	printf("Average time of %d runs in ymm: %f ms\n\n", numofruns, ave_time);



	
	free(A);
	free(B);
	return 0;
}