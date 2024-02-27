
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>

__global__ void printThreadIds()
{
	printf("ThreadIdx.x = %d, ThreadIdx.y = %d, ThreadIdx.z = %d \n", threadIdx.x, threadIdx.y, threadIdx.z);
	printf("BlockIdx.x = %d, BlockIdx.y = %d, BlockIdx.z = %d, BlockDim.x = %d, BlockDim.y = %d, GridDim.x = %d, GridDim.y = %d \n", 
		blockIdx.x, blockIdx.y, blockIdx.z, blockDim.x, blockDim.y, gridDim.x, gridDim.y);
}

int main()
{
	// 256 threads, each block is 8 * 8 threads, grid is 2 * 2
	/*int nx = 16; //Total threads in X direction
	int ny = 16; //Total threads in y direction

	dim3 block(8,8);
	dim3 grid(nx/block.x, ny/block.y);*/

	//  16 Threasds each block is 2 * 2 * 2 threads, 3D grid is 2 * 2 * 2
	int nx = 4; //Total threads in X direction
	int ny = 4; //Total threads in y direction

	dim3 block(2,2);
	dim3 grid(nx/block.x, ny/block.y);

	printThreadIds << <grid, block >> > ();
	cudaDeviceSynchronize();
	 
	cudaDeviceReset();
	return 0;
}
