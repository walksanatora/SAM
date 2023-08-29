#include "reciter.h"
#include "sam.h"

extern int sam_debug;

struct AudioResult {
    int res;
    int buf_size;
    char *buf;
};

struct AudioResult* speakText(unsigned char pitch,unsigned char speed,unsigned char throat,unsigned char mouth,char *input);
