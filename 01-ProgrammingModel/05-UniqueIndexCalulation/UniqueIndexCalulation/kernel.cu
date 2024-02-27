
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>

/*__global__ void uniqueIndexCalcThreadidx(int* input)
{
	int tid = threadIdx.x;
	printf("ThreadIdx.x = %d, BlockIdx.x = %d, GirdDim.x = %d,   value = %d \n", tid, blockIdx.x, gridDim.x, input[tid]);
}*/

/*
* Here, we do not calculate global indices in a way that, threads with in same thread block access consecutive
* memory locations or condecutive elements in array
* 
*	0	1		2	3
*	4	5		6	7	
* 
* ArrayIndex = threadId + offset (blockId.x * blockDim.x) --> grid: M blocks * 1 block
* ArrayIndex = threadId + offset (row offset + block offset) --> grid: M blocks * N block
*			Number of threads in one row = gridDim.x * blockDim.x
*			tid + ()
*			
*/
__global__ void uniqueIndexCalcThreadidx_2x1d(int* input)
{
	int tid = threadIdx.x;
	//int offset = (blockIdx.x * blockDim.x); // grid: M blocks * 1 block
	int offset = (blockIdx.x * blockDim.x) + (blockIdx.y * blockDim.x * gridDim.x); // grid: M blocks * N block
	int gid = tid + offset;
	printf("ArrayIndex = %d, ThreadIdx.x = %d, BlockIdx.x = %d, BlockIdx.y = %d, GirdDim.x = %d, GirdDim.y = %d, value = %d \n", gid, tid, blockIdx.x, blockIdx.y, gridDim.x, gridDim.y, input[gid]);
}

/*
* Here, we do not calculate global indices in a way that, threads with in same thread block access consecutive
* memory locations or condecutive elements in array
* 
* Array Indices in grid
*	0	1		4	5
*	2	3		6	7
* 
*	8	9		12	13
*	10	11		14	15
* 
* 
* block_offset = blockDim.x * blockDim.y (number of threads in block) * blockIdx.x
* row_offset = blockDim.x * blockDim.y * girdDim.y (number of threads in a row) * blockIdx.y
* 
* 
* 
*/
__global__ void uniqueIndexCalcThreadidx_2x2d(int* input)
{
	int tid = threadIdx.x;
	
	int block_offset = blockDim.x * blockDim.y * blockIdx.x;
	int row_offset = blockDim.x * blockDim.y * gridDim.y * blockIdx.y;

	int gid = tid + block_offset + row_offset;
	printf("ArrayIndex = %d, ThreadIdx.x = %d, BlockIdx.x = %d, BlockIdx.y = %d, GirdDim.x = %d, GirdDim.y = %d, value = %d \n", gid, tid, blockIdx.x, blockIdx.y, gridDim.x, gridDim.y, input[gid]);
}

int main()
{
	//int arraySize = 8;
	int arraySize = 16;
	int arrayByteSize = sizeof(int) * arraySize;
	//int arrayData[] = {0, 5, 10, 15, 20, 25, 30, 35};
	int arrayData[] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16};

	printf("Array Data\n");
	for (int i = 0; i < arraySize; i++)
	{
		printf("%d ", arrayData[i]);
	}
	printf("\n \n");

	//Copying data to device from host
	int* devData; 
	cudaMalloc((void**)&devData, arrayByteSize);
	cudaMemcpy(devData, arrayData, arrayByteSize, cudaMemcpyHostToDevice);

	/*int nx = 8; //Total threads in X direction
	int ny = 1; //Total threads in y direction

	//dim3 block(8,1); // Block size 8 * 1, grid size 1 * 1
	dim3 block(4, 1); // Block size 4 * 1, grid size 2 * 1
	dim3 grid(nx/block.x, ny/block.y);*/

	int nx = 8; //Total threads in X direction
	int ny = 2; //Total threads in y direction

	//dim3 block(8,1); // Block size 8 * 1, grid size 1 * 1
	dim3 block(4, 1); // Block size 4 * 1, grid size 2 * 1
	dim3 grid(nx / block.x, ny / block.y);

	printf("*** 2D Grid-1 : Consecutive assignment in row wise in grid ***\n\n");
	uniqueIndexCalcThreadidx_2x1d << <grid, block >> > (devData);
	cudaDeviceSynchronize();
	cudaDeviceReset();

	//Copying data to device from host
	int* devData2;
	cudaMalloc((void**)&devData2, arrayByteSize);
	cudaMemcpy(devData, arrayData, arrayByteSize, cudaMemcpyHostToDevice);
	printf("*** 2D Grid-2 : Based on Memory Allocation in block ***\n\n");
	uniqueIndexCalcThreadidx_2x2d << <grid, block >> > (devData);
	cudaDeviceSynchronize();
	cudaDeviceReset();
	return 0;
}
