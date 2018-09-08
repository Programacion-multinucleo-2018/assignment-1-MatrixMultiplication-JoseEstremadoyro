#include <stdio.h>
#include <chrono>


__global__
void multiplyCell(int N, int * a, int * b, int * c){

    // We get the index of the current data 
    unsigned int threadx = blockDim.x * blockIdx.x + threadIdx.x;
    unsigned int thready = threadIdx.y + blockIdx.y * blockDim.y;
    unsigned int threadxy = thready * N + threadx;

    // Then we get the col and row
    int row = threadxy / N;
    int col = threadxy % N;

    if(row < N && col < N){

        // Then we multiply and add each one of them
        int result = 0;
        for(int i=0;i<N;i++){
            result +=a[row*N+i]*b[i*N+col];
        }

        c[threadx]=result;

    }

}

void GPUTimedMatrixMultiplication(int N,int * a,int * b, int * c,
        int ** runs, int runsLength){

    // Allocate in GPU
    int *d_a,*d_b,*d_c;
    int size = N*N*sizeof(int);
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

        //initialize timer
        auto start = std::chrono::high_resolution_clock::now();
        multiplyCell<<<blocksPerGrid,threadsPerBlock>>>(N,d_a,d_b,d_c); 
        //finish timer
        auto end = std::chrono::high_resolution_clock::now();

        std::chrono::duration<float, std::milli> duration_ms = end - start;

        //print result
        printf("GPU test dimensions threads %d %d blocks %d %d N: %d duration: %f\n ms\n",
                run[0],run[1],run[3],run[4],N,duration_ms.count());
        fflush(stdout); 
    }

    // Copy result back from gpu
    cudaMemcpy(c,d_c,size,cudaMemcpyDeviceToHost);

    // Free variables
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);

}

void GPUMatrixMultiplication(int N,int * a,int * b, int * c,
        int * run){

    // Allocate in GPU
    int *d_a,*d_b,*d_c;
    int size = N*N*sizeof(int);
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
