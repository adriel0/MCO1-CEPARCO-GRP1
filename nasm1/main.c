#include <stdio.h>
#include <stdlib.h>
#include <windows.h>
#include <time.h>

int nonavx(int count, int* A, int* b);

int main() {
	int count = 5,ans;
	int *A, *B;
	A = (int*)malloc((size_t)(8 * count));
	B = (int*)malloc((size_t)(8 * count));
	for (int i = 0; i < count; i++)
	{
		A[i] = i + 1;
		B[i] = i + 1;
	}
	ans=nonavx(count,&A,&B);
	for (int i = 0; i < count; i++)
	{
		printf("%d", ans);
	}
	return 0;
}