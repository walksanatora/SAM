#include <ctype.h>

#include "reciter.h"
#include "sam.h"
#include "debug.h"
#include "lib.h"

int sam_debug = 0;

struct AudioResult speakText(unsigned char pitch,unsigned char speed,unsigned char throat,unsigned char mouth,char *input)
{
    int i=0;
    for(i=0; input[i] != 0; i++)
        input[i] = toupper((int)input[i]);
    strncat(input, "[", 255);

    SetPitch(pitch == 0 ? 64 : pitch);
    SetSpeed(speed == 0 ? 72 : speed);
    SetThroat(throat == 0 ? 128 :throat);
    SetMouth(mouth == 0 ? 128 : mouth);
    TextToPhonemes((unsigned char*) input);
    SetInput(input);
    struct AudioResult resp;
    resp.res = SAMMain();
    resp.buf = GetBuffer();
    resp.buf_size = GetBufferLength();
    return resp;
}

