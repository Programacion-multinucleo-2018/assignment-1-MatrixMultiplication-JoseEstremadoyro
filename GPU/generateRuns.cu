#include <stdio.h>
#include <math.h>
void generateRuns(int *** inputRuns,int * length,int N){

    // GetGPUProperties
    cudaDeviceProp props; 
    cudaGetDeviceProperties(&props,0);

    // Get maximum threads, blocks and grids
    printf("Generating test runs using N= %d:\n",N);
    printf("GPU Info\n");
    printf("Name: %s\n",props.name);
    printf("Max Threads Per Block  %d\n",props.maxThreadsPerBlock);
    printf("Max Threads Size  %d %d %d\n",
        props.maxThreadsDim[0],
        props.maxThreadsDim[1],
        props.maxThreadsDim[2]);
    printf("Max Grid Size %d %d %d\n",
        props.maxGridSize[0],
        props.maxGridSize[1],
        props.maxGridSize[2]);
    printf("Compute Capability %d\n",props.major);

    /* Get total number of tests- from linear to squared, 
       from threads to blocks */

    int t;
    if(N*N<props.maxThreadsPerBlock) 
        t = N*N;
    else
        t= props.maxThreadsPerBlock;
    int b = N*N/t+1;

    int threadsToBlocksTests = log2(t/32.0) + 1; 
    int linearToSquareTests = log2(t/1.0) + 1; 
    printf("%d %d\n",threadsToBlocksTests,linearToSquareTests);
    *length = threadsToBlocksTests + linearToSquareTests;

    // Allocate runs
    int ** runs = (int**)malloc((*length)*sizeof(int*));
    for(int i=0;i<*length;i++){
        runs[i] = (int*)malloc(6*sizeof(int));
    }
    
    // Generate the block, grid, threads
    // From linear to squared 
    int j = 0;
    int i;
    for(i=1;j<threadsToBlocksTests;i*=2){
       runs[j][0]= t/i; 
       runs[j][1]= 1; 
       runs[j][2]= 1; 
       runs[j][3]= b*i; 
       runs[j][4]= 1; 
       runs[j][5]= 1; 
       j++;
    }

    // From threads to blocks
    for(i=1;j<*length;i*=2){
       runs[j][0]= t/i; 
       runs[j][1]= i; 
       runs[j][2]= 1; 
       runs[j][3]= b; 
       runs[j][4]= 1; 
       runs[j][5]= 1; 
       j++;
    }
    *inputRuns = runs;

}

