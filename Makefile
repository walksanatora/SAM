_OBJS = reciter.o sam.o render.o main.o debug.o lib.o
_LIBS = reciter.o sam.o render.o lib.o debug.o

#CC = gcc
#CC = emcc
CC=emcc

ODIR = target/c
SDIR = sam

OBJS = $(patsubst %,$(ODIR)/%,$(_OBJS))
LIBS = $(patsubst %,$(ODIR)/%,$(_LIBS))

# no libsdl present
BFLAGS = -fPIC
CFLAGS = $(BFLAGS) -Wall -O3 -I/usr/lib/jvm/java-17-openjdk/include/linux
LFLAGS = $(BFLAGS) -s WASM=1 -s INITIAL_MEMORY=196608 -s TOTAL_STACK=48736 -s STANDALONE_WASM=1 -s PURE_WASI=1 -s STACK_OVERFLOW_CHECK=0 -s WASM_BIGINT=1 -s ABORTING_MALLOC=0 -s MEMORY_GROWTH_GEOMETRIC_STEP=0 -s IMPORTED_MEMORY=1 -s ALLOW_MEMORY_GROWTH=1 -s EXPORTED_FUNCTIONS='["_free","_malloc","_setupSpeak","_speakText"]'

sam: target/c $(OBJS)
	$(CC) -o $(ODIR)/sam-inline $(OBJS) $(LFLAGS)

target/c/wasm_rt_impl.kt:
	wget "https://raw.githubusercontent.com/SoniEx2/wasm2kotlin/wasm2kotlin/wasm2kotlin/wasm_rt_impl.kt"
	mv wasm_rt_impl.kt target/c

kotlin: lib target/c/wasm_rt_impl.kt
	~/git/wasm2kotlin/build/wasm2kotlin target/c/libsam.so > libsam.kt
	kotlinc -d wasmrt.jar target/c/wasm_rt_impl.kt
	kotlinc -d libsam.jar -cp wasmrt.jar libsam.kt 

lib: target/c $(LIBS)
	$(CC) -shared -o $(ODIR)/libsam.so $(LIBS) $(LFLAGS) -Wl

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
