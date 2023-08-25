#include <jni.h>
#include "lib.h"
/* Header for class net.walksanator.tts_mc.jni.SAMTextToSpeech */

/*
 * Class:     net_walksanator_tts_mc_jna_SAMTextToSpeech
 * Method:    speakMessage
 * Signature: (BBBBLjava/lang/String;)[S
 */
JNIEXPORT jshortArray JNICALL Java_net_walksanator_tts_1mc_jni_SAMTextToSpeech_speakMessage
  (JNIEnv *env, jobject this, jbyte pitch, jbyte speed, jbyte throat, jbyte mouth, jstring message) {
    char *cStr = GetStringUTFChars(env, message, JNI_FALSE);
    struct AudioResult res = speakText(pitch,speed,throat,mouth,cStr);
    
  }
