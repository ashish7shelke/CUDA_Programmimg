
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>

__global__ void printThreadIds()
{
	printf("ThreadIdx.x = %d, ThreadIdx.y = %d, ThreadIdx.z = %d \n", threadIdx.x, threadIdx.y, threadIdx.z);
}

int main()
{
	int nx = 16; //Total threads in X direction
	int ny = 16; //Total threads in y direction

	dim3 block(8,8);
	dim3 grid(nx/block.x, ny/block.y);

	printThreadIds << <grid, block >> > ();
	cudaDeviceSynchronize();
	 
	cudaDeviceReset();
	return 0;
}
