LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_MODULE := bindings
LOCAL_SRC_FILES := \
	/Users/flairyparagon/AndroidStudioProjects/PowerTutor-master/app/src/main/jni/Android.mk \
	/Users/flairyparagon/AndroidStudioProjects/PowerTutor-master/app/src/main/jni/bindings.cpp \

LOCAL_C_INCLUDES += /Users/flairyparagon/AndroidStudioProjects/PowerTutor-master/app/src/main/jni
LOCAL_C_INCLUDES += /Users/flairyparagon/AndroidStudioProjects/PowerTutor-master/app/src/debug/jni

include $(BUILD_SHARED_LIBRARY)
