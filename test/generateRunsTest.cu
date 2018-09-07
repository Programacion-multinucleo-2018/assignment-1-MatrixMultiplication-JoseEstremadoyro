#include "../GPU/generateRuns.h"
#include <stdio.h>

void test(int N);

int main(){
    test(200);
    test(2000);
    test(5000);
}

void test(int N){
    
    int ** runs;
    int runsLength;
    generateRuns(&runs,&runsLength,N);
    printf("%d\n",runsLength);
    for(int i=0;i<runsLength;i++){
        for(int j=0;j<6;j++){
            printf("%d ",runs[i][j]);
        }
        printf("\n");
        free(runs[i]);
    }
    free(runs);

}
