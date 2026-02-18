TARGET := iphone:clang:14.5:14.0
INSTALL_TARGET_PROCESSES = YouTube

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FBAutoTool
FBAutoTool_FILES = Tweak.x
FBAutoTool_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
