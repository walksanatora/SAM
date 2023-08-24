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
    SetInput(input);
    int res = SAMMain();
    char *buf = GetBuffer();
    int buf_size = GetBufferLength();
    struct AudioResult resp;
    resp.res = res;
    resp.buf = buf;
    resp.buf_size = buf_size;
    return resp;
}

