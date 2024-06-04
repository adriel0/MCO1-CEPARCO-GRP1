#include <stdio.h>
#include <stdlib.h>
#include <windows.h>
#include <time.h>

long long int nonavx(long long int count, long long int* A, long long int* b);

int main() {
	long long int count = 5,ans;
	long long int* A = malloc(count * sizeof(long long int));
	long long int* B = malloc(count * sizeof(long long int));
	for (long long int i = 0; i < count; i++)
	{
		A[i] = i + 1;
		B[i] = i + 1;
	}
	ans=nonavx(count,A,B);
	printf("%d", ans);
	
	return 0;
}