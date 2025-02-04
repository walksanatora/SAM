_OBJS = reciter.o sam.o render.o main.o debug.o lib.o
_LIBS = reciter.o sam.o render.o lib.o debug.o
CC = gcc

ODIR = target/c
SDIR = sam

OBJS = $(patsubst %,$(ODIR)/%,$(_OBJS))
LIBS = $(patsubst %,$(ODIR)/%,$(_LIBS))

# no libsdl present
#BFLAGS = -fsanitize=address -g
CFLAGS = $(BFLAGS) -Wall -Os -fPIC -I/usr/lib/jvm/java-20-openjdk/include -I/usr/lib/jvm/java-17-openjdk/include/linux
LFLAGS = $(BFLAGS) -fPIC

sam: target/c $(OBJS)
	$(CC) -o $(ODIR)/sam-inline $(OBJS) $(LFLAGS)

lib: target/c $(LIBS)
	$(CC) -shared -o $(ODIR)/libsam.so $(LIBS) $(LFLAGS) -Wl,-soname,libsam.so

target/c:
	mkdir -p target/c

$(ODIR)/%.o: $(SDIR)/%.c
	$(CC) -c -o $@ $< $(CFLAGS)

package:
	tar -cvzf sam.tar.gz README.md Makefile sing src/

clean:
	rm -f *.o

archive:
	rm -f sam_windows.zip
	cd ..; zip SAM/sam_windows.zip	SAM/sam.exe SAM/SDL.dll SAM/README.md SAM/demos/*.bat
