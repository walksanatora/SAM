#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <stdlib.h>

#include "lib.h"

void WriteWav(char *filename, char *buffer, int bufferlength)
{
    FILE *file = fopen(filename, "wb");
    if (file == NULL)
        return;
    // RIFF header
    fwrite("RIFF", 4, 1, file);
    unsigned int filesize = bufferlength + 12 + 16 + 8 - 8;
    fwrite(&filesize, 4, 1, file);
    fwrite("WAVE", 4, 1, file);

    // format chunk
    fwrite("fmt ", 4, 1, file);
    unsigned int fmtlength = 16;
    fwrite(&fmtlength, 4, 1, file);
    unsigned short int format = 1; // PCM
    fwrite(&format, 2, 1, file);
    unsigned short int channels = 1;
    fwrite(&channels, 2, 1, file);
    unsigned int samplerate = 22050;
    fwrite(&samplerate, 4, 1, file);
    fwrite(&samplerate, 4, 1, file); // bytes/second
    unsigned short int blockalign = 1;
    fwrite(&blockalign, 2, 1, file);
    unsigned short int bitspersample = 8;
    fwrite(&bitspersample, 2, 1, file);

    // data chunk
    fwrite("data", 4, 1, file);
    fwrite(&bufferlength, 4, 1, file);
    fwrite(buffer, bufferlength, 1, file);

    fclose(file);
}

int main(int argc, char **argv)
{
    setupSpeak(0,0,0,0);
    int i;
    char input[256];
    while (1)
    {
        for (i = 0; i < 256; i++)
            input[i] = 0; // Nullify the input buffer

        if (fgets(input,256,stdin) == NULL) {
            break;
        };

        //strncat(input, "amazing test program", 255); // copy the string into the buffer

        struct AudioResult *resp = speakText(input); // speak the buffer

        fwrite(resp->buf, sizeof(char), resp->buf_size/50, stdout);
        WriteWav("test.wav",resp->buf,resp->buf_size/50);
        fflush(stdout);

        //aint nobody leaking memory on my watch
        free(resp);
    }
    return 0;
}
