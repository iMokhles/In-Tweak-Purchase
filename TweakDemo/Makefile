GO_EASY_ON_ME = 1
TARGET=iphone:clang:latest:7.0
ADDITIONAL_CFLAGS = -fobjc-arc
ARCHS = armv7 arm64

THEOS_BUILD_DIR = debs

include theos/makefiles/common.mk

TWEAK_NAME = TweakDemo
TweakDemo_FILES = Tweak.xm
TweakDemo_FRAMEWORKS = UIKit Foundation CoreGraphics QuartzCore CoreImage Accelerate AVFoundation AudioToolbox MobileCoreServices Social Accounts MediaPlayer ImageIO CoreMedia MessageUI AssetsLibrary Security SystemConfiguration
TweakDemo_PRIVATE_FRAMEWORKS = AppSupport
TweakDemo_LIBRARIES = MobileGestalt DevelopersLib_ET sqlite3 z stdc++.6
TweakDemo_LDFLAGS = -F./Frameworks/ -framework InTweakPurchase -framework Bolts -framework Parse -framework ParseCrashReporting -framework ParseFacebookUtils -framework ParseUI
TweakDemo_CFLAGS += -F./Frameworks/ 

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
