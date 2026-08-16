MODULES = shook

TWEAK_NAME = Stella

$(TWEAK_NAME)_FILES = $(shell find Sources/Stella -name '*.swift') $(shell find Sources/StellaC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
$(TWEAK_NAME)_SWIFTFLAGS = -ISources/StellaC/include
$(TWEAK_NAME)_CFLAGS = -fobjc-arc -ISources/StellaC/include
$(TWEAK_NAME)_FRAMEWORKS = UIKit

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk