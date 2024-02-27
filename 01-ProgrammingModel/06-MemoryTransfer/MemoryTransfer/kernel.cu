
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <cstring>

__global__ void memoryTransferTest(int* input)
{
	int gid = threadIdx.x + (blockIdx.x * blockDim.x);
	//if(gid < size)
	printf("gid = %d, tid = %d, value = %d \n", gid, threadIdx.x, input[gid]);
}

int main()
{
	int size = 128;
	int arraySize = size * sizeof(int);

	dim3 block(64);
	dim3 grid(2);

	int* hostInput = NULL;
	hostInput = (int*)malloc(arraySize);

	time_t clock;
	srand((unsigned)time(&clock));

	for (int i = 0; i < size; i++)
	{
		hostInput[i] = ((int)rand() & 0xff);
	}

	int* devInput;
	cudaMalloc((void**)&devInput, arraySize);
	cudaMemcpy(devInput, hostInput, arraySize, cudaMemcpyHostToDevice);

	memoryTransferTest << < grid, block>> > (devInput);
	cudaDeviceSynchronize();
	cudaDeviceReset();
	return 0;
}
