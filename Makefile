_OBJS = reciter.o sam.o render.o main.o debug.o lib.o
_LIBS = reciter.o sam.o render.o lib.o debug.o

#CC = gcc
#CC = emcc
#CC=emcc
CC=clang
ODIR = target/c
SDIR = sam

OBJS = $(patsubst %,$(ODIR)/%,$(_OBJS))
LIBS = $(patsubst %,$(ODIR)/%,$(_LIBS))

# no libsdl present
BFLAGS = --target=wasm32
CFLAGS = $(BFLAGS) -Wall -Oz
#LFLAGS1 = -s WASM=1 -s STANDALONE_WASM=1 -s PURE_WASI=1
#LFLAGS2 = -s INITIAL_MEMORY=196608 -s TOTAL_STACK=48736
#LFLAGS = $(BFLAGS) $(LFLAGS1) $(LFLAGS2) -s STACK_OVERFLOW_CHECK=0 -s WASM_BIGINT=1 -s ABORTING_MALLOC=0 -s MEMORY_GROWTH_GEOMETRIC_STEP=0 -s IMPORTED_MEMORY=1 -s ALLOW_MEMORY_GROWTH=1 -s EXPORTED_FUNCTIONS='["_free","_malloc","_setupSpeak","_speakText"]' 

sam: target/c $(OBJS)
	$(CC) -o $(ODIR)/sam-inline $(OBJS) $(LFLAGS)

kotlin: lib
	~/git/wasm2kotlin/build/wasm2kotlin target/c/libsam.wasm -p "net.walksanator.aeiou.wasm" -c SamWasm > ~/git/projects/aeiou/aeiou-mc/src/main/java/net/walksanator/aeiou/wasm/libsam.kt

lib: target/c $(LIBS)
	$(CC) --no-entry -o $(ODIR)/libsam.so $(LIBS) $(LFLAGS) -Wl

target/c:
	mkdir -p target/c

$(ODIR)/%.o: $(SDIR)/%.c
	$(CC) -c -o $@ $< $(CFLAGS)

package:
	tar -cvzf sam.tar.gz README.md Makefile sing src/

clean:
	rm -f target/c/*
	rm *.jar
	rm *.kt

archive:
	rm -f sam_windows.zip
	cd ..; zip SAM/sam_windows.zip	SAM/sam.exe SAM/SDL.dll SAM/README.md SAM/demos/*.bat
