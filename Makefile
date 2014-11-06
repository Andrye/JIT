CXX ?= g++
ASM ?= nasm
CXXFLAGS = -Wall -std=c++0x -O2 -g -c
ASMFLAGS = -O0 -felf64
SOURCES = main.cpp mallocx.cpp compile.cpp tools.asm
OBJECTS_ = $(SOURCES:.cpp=.o)
OBJECTS = $(OBJECTS_:.asm=.o)
EXECUTABLES = exec 

exec: $(OBJECTS)
	$(CXX) -o $@ $?

main.o : main.cpp
	$(CXX) $(CXXFLAGS)  $? -o $@

mallocx.o : mallocx.cpp
	$(CXX) $(CXXFLAGS)  $? -o $@

compile.o : compile.cpp
	$(CXX) $(CXXFLAGS) $? -o $@

tools.o : tools.asm
	$(ASM) $? $(ASMFLAGS) -o $@

.PHONY : clean

clean :
	rm -f $(OBJECTS) $(EXECUTABLES)
