CC=nvcc

INCLUDES=-I$(CUDA_HOME)/extras/CUPTI/include 
LINK=-L$(CUDA_HOME)/extras/CUPTI/lib64

ARCH=-arch sm_86

LIBS=-lcuda -lcupti -lstdc++ -lm

CXXFLAGS=-Xcompiler -fopenmp 

all:hpc_example 

hpc_example: hpc_example.o
	$(CC) $(CXXFLAGS) -o $@ $^ $(ARCH) $(LIBS) $(LINK)    

hpc_example.o: hpc_example.cu
	$(CC) -c $< $(INCLUDES)  


run:hpc_example 
	./$<

run-trace:hpc_example 
	hpcrun -o out.m -e REALTIME -e gpu=nvidia -t ./$<
	hpcstruct --gpucfg no out.m
	hpcprof -o out.d out.m

run-pc:hpc_example  
	hpcrun -o out.m -e REALTIME -e gpu=nvidia,pc ./$<
	hpcstruct --gpucfg yes out.m
	hpcprof -o out.d out.m

clean:
	rm -rf hpc_example.o hpc_example out.m out.d