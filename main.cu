#include <stdlib.h>
#include "CPU/matrixMultiplication.h"
#include "CPUOMP/matrixMultiplication.h"
#include "GPU/matrixMultiplication.h"
#include "GPU/generateRuns.h"
#include <chrono>

//Fills in both of the arrays with random numbers
void initialData(int N,int * a,int * b){

    for(int i =0;i<N;i++){
        for(int j =0;j<N;j++){
            a[i*N+j] = rand() % 100; 
            b[i*N+j] = rand() % 100; 
        }
    }

}

void timedTest(int N){

    // Generate the data
    int *x = new int[N*N];
    int *y = new int[N*N];
    int *z = new int[N*N];
    initialData(N,x,y);

    // Initialize timer
    auto start = std::chrono::high_resolution_clock::now();
    // Test on CPU
    CPUMatrixMultiplication(N,x,y,z);
    // Finish timer
    auto end = std::chrono::high_resolution_clock::now();
    
    std::chrono::duration<float, std::milli> duration_ms = end - start;
    printf("CPU test N: %d duration %f ms",N,duration_ms.count());
    fflush(stdout); 

    // Initialize timer
    start = std::chrono::high_resolution_clock::now();
    // Test on CPU with OMP
    CPUOMPMatrixMultiplication(N,x,y,z);
    // Finish timer
    end = std::chrono::high_resolution_clock::now();
    fflush(stdout); 
    
    duration_ms = end - start;
    printf("CPU OMP test N: %d duration %f ms",N,duration_ms.count());

    int ** runs;
    int runsLength;
    generateRuns(&runs,&runsLength,N);

    // Test on CUDA until there is an error
    GPUTimedMatrixMultiplication(N,x,y,z,runs,runsLength);

    for(int i=0;i<runsLength;i++){
        free(runs[i]);
    }
    free(runs);

    // Free all memory
    delete [] x;
    delete [] y;
    delete [] z;
}

int main(int argc, char ** argv){

    // We run the Tests and the results will be printed
    timedTest(1000);
    timedTest(1200);
    timedTest(2000);
    timedTest(4000);
    return 0;

}
