#AUDIO_POLICY_TEST := true
#ENABLE_AUDIO_DUMP := true

LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
    AudioHardware.cpp \
    audio_hw_hal.cpp

ifeq ($(BOARD_HAVE_QCOM_FM),true)
    LOCAL_CFLAGS += -DWITH_QCOM_FM
endif

LOCAL_SHARED_LIBRARIES := \
    libcutils       \
    libutils        \
    libmedia        \
    libaudioalsa

$(shell mkdir -p $(OUT)/obj/SHARED_LIBRARIES/libaudioalsa_intermediates/)
$(shell touch $(OUT)/obj/SHARED_LIBRARIES/libaudioalsa_intermediates/export_includes)

ifeq ($(BOARD_USES_QCOM_AUDIO_CALIBRATION),true)
    LOCAL_SHARED_LIBRARIES += libaudcal
    LOCAL_CFLAGS += -DWITH_QCOM_CALIBRATION

    $(shell mkdir -p $(OUT)/obj/SHARED_LIBRARIES/libaudcal_intermediates/)
    $(shell touch $(OUT)/obj/SHARED_LIBRARIES/libaudcal_intermediates/export_includes)
endif

ifneq ($(TARGET_SIMULATOR),true)
    LOCAL_SHARED_LIBRARIES += libdl
endif

LOCAL_STATIC_LIBRARIES := \
    libmedia_helper \
    libaudiohw_legacy

LOCAL_MODULE := audio.primary.msm7x30

LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)/hw
LOCAL_MODULE_TAGS := optional

LOCAL_CFLAGS += -fno-short-enums

LOCAL_C_INCLUDES := $(TARGET_OUT_HEADERS)/mm-audio/audio-alsa
ifeq ($(BOARD_USES_QCOM_AUDIO_CALIBRATION),true)
    LOCAL_C_INCLUDES += $(TARGET_OUT_HEADERS)/mm-audio/audcal
endif
LOCAL_C_INCLUDES += hardware/libhardware/include
LOCAL_C_INCLUDES += hardware/libhardware_legacy/include
LOCAL_C_INCLUDES += frameworks/base/include
LOCAL_C_INCLUDES += system/core/include

LOCAL_C_INCLUDES += $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/include
LOCAL_ADDITIONAL_DEPENDENCIES := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr

include $(BUILD_SHARED_LIBRARY)


# The audio policy is implemented on top of legacy policy code
include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
    AudioPolicyManager.cpp \
    audio_policy_hal.cpp

LOCAL_SHARED_LIBRARIES := \
    libcutils \
    libutils \
    libmedia

LOCAL_STATIC_LIBRARIES := \
    libmedia_helper \
    libaudiopolicy_legacy

LOCAL_MODULE := audio_policy.msm7x30

LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)/hw
LOCAL_MODULE_TAGS := optional

ifeq ($(BOARD_HAVE_BLUETOOTH),true)
    LOCAL_CFLAGS += -DWITH_A2DP
endif

LOCAL_C_INCLUDES := hardware/libhardware_legacy/audio

LOCAL_C_INCLUDES += $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/include
LOCAL_ADDITIONAL_DEPENDENCIES := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr

include $(BUILD_SHARED_LIBRARY)
