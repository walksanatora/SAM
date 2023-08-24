#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

#include "reciter.h"
#include "sam.h"
#include "debug.h"
#include "lib.h"

int debug = 0;

struct AudioResult speakText(unsigned char pitch,unsigned char speed,unsigned char throat,unsigned char mouth,char *input)
{
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

