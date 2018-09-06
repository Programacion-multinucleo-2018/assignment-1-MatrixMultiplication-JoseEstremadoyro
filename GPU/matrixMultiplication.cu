#include <stdio.h>

__global__
void multiplyCell(int N,int * a, int * b, int * c){

    // We get the index of the current data 
    unsigned int threadx = blockDim.x * blockIdx.x + threadIdx.x;

    // Then we get the col and row
    int row = threadx % N;
    int col = threadx / N;

    // Then we multiply and add each one of them
    int result = 0;
    /*for(int i=0;i<N;i++){
        //result +=a[row*N+i]+b[i*N+col];
    }*/
    result = a[threadx]+b[threadx];
    c[threadx]=result;

}

void GPUTimedMatrixMultiplication(int N,int * a,int * b, int * c,

        int ** runs, int runsLength){

    // Allocate in GPU
    int *d_a,*d_b,*d_c;
    int size = N*sizeof(int);
    cudaMalloc(&d_a,size);
    cudaMalloc(&d_b,size);
    cudaMalloc(&d_c,size);

    // Transfer to device
    cudaMemcpy(d_a,a,size,cudaMemcpyHostToDevice);
    cudaMemcpy(d_b,b,size,cudaMemcpyHostToDevice);

    // Declare time tables with corresponding data :todo

    // Call kernel with the blocks, grid and threads specified
    for(int i=0;i<runsLength;i++){

        int * run = runs[i];
        dim3 blocksPerGrid(run[0],run[1],run[2]);
        dim3 threadsPerBlock(run[3],run[4],run[5]);

        // Gather initial time :todo
        multiplyCell<<<blocksPerGrid,threadsPerBlock>>>(N,a,b,c); 
        // Gather finishing time :todo

    }

    // Copy result back from gpu
    cudaMemcpy(d_c,c,size,cudaMemcpyDeviceToHost);

    // Print time table :todo

    // Free variables
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);

}

void GPUMatrixMultiplication(int N,int * a,int * b, int * c,
        int * run){

    // Allocate in GPU
    int *d_a,*d_b,*d_c;
    int size = N*sizeof(int);
    cudaMalloc(&d_a,size);
    cudaMalloc(&d_b,size);
    cudaMalloc(&d_c,size);

    // Transfer to device
    cudaMemcpy(d_a,a,size,cudaMemcpyHostToDevice);
    cudaMemcpy(d_b,b,size,cudaMemcpyHostToDevice);

    // Call kernel with the blocks, grid and threads specified
    dim3 blocksPerGrid(run[0],run[1],run[2]);
    dim3 threadsPerBlock(run[3],run[4],run[5]);
    multiplyCell<<<blocksPerGrid,threadsPerBlock>>>(N,d_a,d_b,d_c); 

    // Copy result back from gpu
    cudaMemcpy(c,d_c,size,cudaMemcpyDeviceToHost);

    // Free variables
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);

}
