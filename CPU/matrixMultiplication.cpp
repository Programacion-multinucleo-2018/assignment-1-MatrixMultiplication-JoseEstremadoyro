
// Matrix multiplication function using cpu

void CPUMatrixMultiplication(int N,int*a,int*b,int*c){
    int result; 
    for(int i=0;i<N;i++){
        for(int j=0;j<N;j++){
            result= 0;
            for(int n=0;n < N;n++){
                result+=a[i*N+n]*b[n*N+j]; 
            }
            c[i*N+j]=result;
        }
    }
}
