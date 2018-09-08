main:
	nvcc -std=c++11 main.cu CPU/matrixMultiplication.cpp\
	   	CPUOMP/matrixMultiplication.cpp GPU/matrixMultiplication.cu\
		 GPU/generateRuns.cu\
	   	-o bin/program


tests: gpuTest cpuTest cpuOmpTest generateRunsTest

gpuTest:
	nvcc -std=c++11 test/gpuTest.cu GPU/matrixMultiplication.cu\
	   	-o test/bin/GPUtest

cpuTest:
	g++ test/cpuTest.cpp CPU/matrixMultiplication.cpp -o test/bin/CPUTest

cpuOmpTest:
	g++ test/cpuOmpTest.cpp CPUOMP/matrixMultiplication.cpp\
	   	-o test/bin/CPUOMPTest

generateRunsTest:
	nvcc -std=c++11 GPU/generateRuns.cu test/generateRunsTest.cu\
	   	-o test/bin/generateRunsTest


clean:
	rm test/bin/* bin/*
