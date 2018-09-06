#include <stdio.h>

__global__
void multiplyCell(int N,int * a, int * b, int * c){

        

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

    // Print time table :todo

    // Free variables
    cudaFree(d_a);
    cudaFree(d_b);


}

void GPUMatrixMultiplication(int N,int * a,int * b, int * c,

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

    // Call kernel with the blocks, grid and threads specified
    for(int i=0;i<runsLength;i++){

        int * run = runs[i];
        dim3 blocksPerGrid(run[0],run[1],run[2]);
        dim3 threadsPerBlock(run[3],run[4],run[5]);
        multiplyCell<<<blocksPerGrid,threadsPerBlock>>>(N,a,b,c); 

    }

    // Free variables
    cudaFree(d_a);
    cudaFree(d_b);

}
