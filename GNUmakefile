include $(GNUSTEP_MAKEFILES)/common.make

FRAMEWORK_NAME=PackageManager
# TODO: VERSION=?
PackageManager_HEADER_FILES = \
	PackageManager.h \
	PMPackage.h \
	PMDatabase.h \
	PMTransaction.h \
	PMLocalDatabase.h \
	PMPackageManager.h
PackageManager_OBJC_FILES = \
	PMPackage.m \
	PMDatabase.m \
	PMTransaction.m \
	PMLocalDatabase.m \
	PMPackageManager.m
PackageManager_LDFLAGS = -lalpm

-include GNUmakefile.preamble
include $(GNUSTEP_MAKEFILES)/framework.make
-include GNUmakefile.postamble

