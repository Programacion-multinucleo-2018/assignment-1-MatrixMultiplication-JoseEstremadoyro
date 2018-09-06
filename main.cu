#include <stdlib.h>
#include "CPU/matrixMultiplication.h"
#include "CPUOMP/matrixMultiplication.h"
#include "GPU/matrixMultiplication.h"
#include "GPUTestingHelpers.h"

//Fills in both of the arrays with random numbers
void initialData(int N,int * a,int * b){

    for(int i =0;i<N;i++){
        for(int j =0;j<N;j++){
            a[i*N+j] = rand() % 100; 
            b[i*N+j] = rand() % 100; 
        }
    }

}

void test(int N){

    // Generate the data
    int *x = new int[N*N];
    int *y = new int[N*N];
    int *z = new int[N*N];
    initialData(N,x,y);

    // Test on CPU
    CPUMatrixMultiplication(N,x,y,z);

    // Test on CPU with OMP
    CPUOMPMatrixMultiplication(N,x,y,z);

    int ** runs;
    int * runsLength;
    generateRuns(runs,runsLength);

    // Test on CUDA until there is an error
    GPUTimedMatrixMultiplication(N,x,y,z,runs,runsLength);

    // Free all memory
    delete [] x;
    delete [] y;

}

void timedTest(int N){

}

int main(int argc, char ** argv){

    // We run the Tests and the results will be printed
    test(1000);
    test(2000);
    test(4000);
    return 0;

}
