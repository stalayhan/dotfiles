all:
	gcc read.c -o read
	gcc write.c -o write

clean:
	rm -rf write read
