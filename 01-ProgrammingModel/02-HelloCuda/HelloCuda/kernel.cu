
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>

__global__ void hello_cuda()
{
	printf("Hello CUDA World !!! \n");
}

int main()
{
	int nx = 16; //Total Threads per block
	int ny = 4; // Total Blocks per grid

	dim3 block(8, 2, 1); // 4 thread in x direction, 1 in y direction, 1 in z direction
	dim3 grid(nx/block.x, ny/block.y, 1); // 8 block in x direction, 1 block in y direction, 1 block in z direction

	//Kernal launch << <grid, block>> > 
	hello_cuda << <grid, block>> > ();

	cudaDeviceSynchronize();

	cudaDeviceReset();
	return 0;
}
