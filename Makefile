ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:13.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = com.cactusutils.ytflex
$(BUNDLE_NAME)_INSTALL_PATH = /var/mobile/Library/Application Support

TWEAK_NAME = YTFlex

EXTRA_CFLAGS := $(addprefix -I,$(shell find ./FLEX -name '*.h' -exec dirname {} \;))
ifeq ($(shell uname -s),Linux)
EXTRA_CFLAGS += -DLINUX
endif

#fidn a way tk exlude theos from the search and make sure tweak wros
$(TWEAK_NAME)_FILES = Tweak.xm $(shell find ./ -type f \( -iname \*.c -o -iname \*.m -o -iname \*.mm \))
$(TWEAK_NAME)_CFLAGS = -fobjc-arc -Wno-error=deprecated-declarations $(EXTRA_CFLAGS)
$(TWEAK_NAME)_CCFLAGS = -std=c++11

include $(THEOS)/makefiles/bundle.mk
include $(THEOS_MAKE_PATH)/tweak.mk
