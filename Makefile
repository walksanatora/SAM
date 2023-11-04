_OBJS = reciter.o sam.o render.o main.o debug.o lib.o
_LIBS = reciter.o sam.o render.o lib.o debug.o

#CC = gcc
#CC = emcc
CC=/opt/wasi-sdk/bin/clang

ODIR = target
OWASM = ${ODIR}/wasm
OKT = ${ODIR}/kotlin
SDIR = sam

OBJS = $(patsubst %,$(OWASM)/%,$(_OBJS))
LIBS = $(patsubst %,$(OWASM)/%,$(_LIBS))

# no libsdl present
BFLAGS = -fPIC --target=wasm32-wasi --sysroot=/opt/wasi-sdk/share/wasi-sysroot
CFLAGS = $(BFLAGS) -Wall -O3 -I/usr/lib/jvm/java-17-openjdk/include/linux
LFLAGS = $(BFLAGS) -nostartfiles -Wl,--no-entry

sam: $(OWASM) $(OBJS)
	$(CC) -o $(OWASM)/sam-inline $(OBJS) $(LFLAGS)

$(OKT):
	mkdir ${OKT}

$(OKT)/wasm_rt_impl.kt: $(OKT)
	wget "https://raw.githubusercontent.com/SoniEx2/wasm2kotlin/wasm2kotlin/wasm2kotlin/wasm_rt_impl.kt"
	mv wasm_rt_impl.kt $(OKT)

kotlin: lib $(OKT)/wasm_rt_impl.kt
	~/git/wasm2kotlin/build/wasm2kotlin $(OWASM)/libsam.so > libsam.kt
	kotlinc -d wasmrt.jar $(OWASM)/wasm_rt_impl.kt
	kotlinc -d libsam.jar -cp wasmrt.jar libsam.kt 

lib: $(OWASM) $(LIBS)
	$(CC) -o $(OWASM)/libsam.so $(LIBS) $(LFLAGS) -Wl

$(OWASM):
	mkdir -p $(OWASM)

$(OWASM)/%.o: $(SDIR)/%.c
	$(CC) -c -o $@ $< $(CFLAGS)

package:
	tar -cvzf sam.tar.gz README.md Makefile sing src/

clean:
	-rm -f $(OWASM)/*
	-rm *.jar
	-rm *.kt
