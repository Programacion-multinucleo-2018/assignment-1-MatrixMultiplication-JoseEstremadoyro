#include <stdio.h>

// Kernel used for getting the result of a single cell

__global__
void multiplyCell(int N,int * a, int * b, int * c);


/* The variable run is an array which contains 
 * the value in 3D for blocksPerGrid and threadsPerBlock */

void GPUMatrixMultiplication(int N,int * a,int * b, int * c,
        int * run);

/* Same function but it receives more run arrays in runs, 
 * a runsLength, which is the length of the array, 
 * and prints the time elapsed between each of the runs */

void GPUTimedMatrixMultiplication(int N,int * a,int * b, int * c,
        int ** runs, int runsLength);
