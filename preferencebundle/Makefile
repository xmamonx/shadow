include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = ShadowSettings

ShadowAPI = $(wildcard ../api/*.m)

ShadowSettings_FILES = $(wildcard *.m) $(ShadowAPI)
ShadowSettings_FRAMEWORKS = Foundation
ShadowSettings_EXTRA_FRAMEWORKS = AltList HookKit
ShadowSettings_PRIVATE_FRAMEWORKS = Preferences AppSupport
ShadowSettings_INSTALL_PATH = /Library/PreferenceBundles
ShadowSettings_CFLAGS = -fobjc-arc -DTHEOS_LEAN_AND_MEAN

include $(THEOS_MAKE_PATH)/bundle.mk
