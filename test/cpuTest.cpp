#include "../CPU/matrixMultiplication.h"
#include <stdio.h>

int main(int argc, char ** argv){

    int * a = new int[4];
    int * b = new int[4];
    int * c = new int[4];

    int i;
    for(i=0;i<4;i++){
        a[i]=i;
    }

    for(i=4;i<8;i++){
        b[i-4]=i;
    }
   

    CPUMatrixMultiplication(2,a,b,c);

    int * correct = new int[4];

    correct[0]=6;
    correct[1]=7;
    correct[2]=26;
    correct[3]=31;

    bool test = true;

    for(i=0;i<4;i++){
        if(c[i] != correct[i]){
            test = false;
        }
    }
    if (test) printf("Test from cpu: passed.\n");
    else printf("Test from cpu: failed.\n");

    delete [] a;
    delete [] b;
    delete [] c;
    delete [] correct;

}
