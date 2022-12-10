TARGET := iphone:clang:14.4:13.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = stellarprefs

stellarprefs_FILES = $(wildcard *.m)
stellarprefs_FRAMEWORKS = UIKit OnBoardingKit
stellarprefs_PRIVATE_FRAMEWORKS = Preferences
stellarprefs_INSTALL_PATH = /Library/PreferenceBundles
stellarprefs_CFLAGS = -fobjc-arc
stellarprefs_EXTRA_FRAMEWORKS = Cephei CepheiPrefs
stellarprefs_LIBRARIES = gcuniversal

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/$(BUNDLE_NAME).plist$(ECHO_END)