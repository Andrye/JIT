exec: main.o tools.o mallocx.o compile.o
	g++ -Wall -o exec main.o tools.o mallocx.o compile.o

main.o : main.cpp
	g++ -Wall -std=c++0x -O2 -c main.cpp -o main.o

mallocx.o : mallocx.cpp
	g++ -Wall -std=c++0x -O2 -c mallocx.cpp -o mallocx.o

compile.o : compile.cpp
	g++ -Wall -std=c++0x -O2 -c compile.cpp -o compile.o

tools.o : tools.asm
	nasm tools.asm -O0 -felf64 -g -o tools.o

.PHONY : clean

clean :
	rm -f *.o exec
