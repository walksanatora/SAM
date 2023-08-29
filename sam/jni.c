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
    char *cStr = (char*) (*env)->GetStringUTFChars(env, message, JNI_FALSE);
    struct AudioResult res = speakText(pitch,speed,throat,mouth,cStr);
    jshortArray shortArray = (*env)->NewShortArray(env, res.buf_size);
    if (shortArray == NULL) {
        return NULL; // Handle the error
    }
    jshort *shortValues = (*env)->GetShortArrayElements(env, shortArray, NULL);
    if (shortValues == NULL) {
        (*env)->DeleteLocalRef(env, shortArray);
        return NULL; // Handle the error
    }
    for (jsize i = 0; i < res.buf_size; i++) {
        shortValues[i] = (jshort) (res.buf[i] - 0x80) << 8;
    }

    (*env)->ReleaseShortArrayElements(env, shortArray, shortValues, 0);

    return shortArray;
  }
