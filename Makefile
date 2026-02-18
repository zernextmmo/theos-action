DEBUG = 0
FINALPACKAGE = 1
TARGET = iphone:clang:latest:14.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FBAutoTool
FBAutoTool_FILES = Tweak.x
FBAutoTool_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
