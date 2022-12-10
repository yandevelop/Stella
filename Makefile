TARGET := iphone:clang:14.4:13.0
INSTALL_TARGET_PROCESSES = SpringBoard
ARCHS = arm64 arm64e
THEOS_DEVICE_IP = localhost
THEOS_DEVICE_PORT = 2222
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Stella

Stella_FILES = Tweak.x
Stella_CFLAGS = -fobjc-arc
Stella_FRAMEWORKS = UIKit
Stella_EXTRA_FRAMEWORKS += Cephei
Stella_LIBRARIES = gcuniversal

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += Preferences
include $(THEOS_MAKE_PATH)/aggregate.mk