# rules.mk - cyrus make tools
#
# Copyright (c) 2024 cyrus cui <cyrus.cui@nokia-sbell.com>
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
########################################################################
#
# brief   : get common variables definations from variable.mk|your_config_file;
#           get target source location form project.mk|your_target_file;
#           export environment for all sub makefile;
#
########################################################################


SINGLE_REPO := Y
ifeq ($(SINGLE_REPO),Y)
PROJ_TOP    := $(CURDIR)
ADMIN_DIR   := $(PROJ_TOP)
else
PROJ_TOP    := $(dir $(CURDIR))
ADMIN_DIR   := $(CURDIR)
endif

MAKEFILE    := $(lastword $(filter-out $(ADMIN_DIR)/make/% ,$(abspath $(MAKEFILE_LIST))))
MAKEFILE_DIR:= $(abspath $(dir $(MAKEFILE)))


.EXPORT_ALL_VARIABLES:
MAKEFLAGS += --no-print-directory

ifeq ($(RULES_MK_INCLUDED),)
RULES_MK_INCLUDED := Y

MKDIR    = /usr/bin/mkdir -p
RM       = /usr/bin/rm -f
MKDEP    = /usr/openwin/bin/makedepend -f -
TOUCH    = /usr/bin/touch
FIND     = /usr/bin/find
XARGS    = /usr/bin/xargs
AWK      = /bin/awk
BASENAME = /bin/basename

CAT      = /bin/cat
CHMOD    = /bin/chmod
CLT      = /usr/atria/bin/cleartool
CMP      = /bin/cmp
CP       = /bin/cp
CUT      = /bin/cut
DIFF     = /bin/diff
ECHO     = /bin/echo
EGREP    = /bin/egrep
FGREP    = /bin/fgrep

AR       = /usr/bin/ar
ARflags  = -r
GREP     = /bin/grep
GZIP     = /bin/gzip
HOSTNAME = /bin/hostname
LN       = /bin/ln -fs
MV       = /bin/mv
NAWK     = /bin/nawk
PRINTF   = /bin/printf
PKGMK    = /usr/bin/pkgmk
PKGTRANS = /usr/bin/pkgtrans
RANLIB   = /usr/ccs/bin/ranlib
RMDIR    = /bin/rmdir
RSH      = /bin/rsh
SED      = /bin/sed
SHELL    = /bin/bash
SLEEP    = /bin/sleep
SORT     = /bin/sort
TAR      = /bin/tar
UNAME    = /bin/uname

LEX      = /bin/lex
RPM      = /usr/bin/rpmbuild
CLT      = /atria/bin/cleartool


CONFIG_MODE  := MK
BUILD_MODE   ?= debug
BUILD_ARCH   := rhlinux


define uniq =
	$(eval seen :=)
	$(foreach _,$1,$(if $(filter $_,$(seen)),,$(eval seen += $_)))
	$(seen)
endef

ifeq ($(CONFIG_MODE),MK)
include $(ADMIN_DIR)/make/variable.mk
else
$(info --> make SURE you want work with third-party configuration system)
$(info --> edit below porting content to your's style)

# Just for example <---------- START
GMPS_ARCH      := rhlinux
GMPS_BUILD_MODE?= debug
TSUFF          = .so
SUBSYS         = home
GMPS_PROJECT   = ims
GMPS_DO        = $(GMPS_TOP)_do
GMPS_HOME      = $(ADMIN_DIR)/gmps
GMS_TARGET     = $(GMPS_HOME)/etc/$(GMPS_PROJECT)/common/gms_targets
GMS_CONFIG     = $(GMPS_HOME)/etc/$(GMPS_PROJECT)/$(GMPS_ARCH)/gms_config
GMS_BIN_DIR    = $(GMPS_HOME)/bin
GENPATH        = $(GMPS_TOP)_do/gen/include
GENINC         = -I$(GENPATH)

# example: get configuration from gms_targets with perl
define get_target_path
    $(shell perl -e '$$common_path="$(dir $(GMS_TARGET))"; \
        $$GMPS_TOP="$(GMPS_TOP)"; \
        push(@INC,"$(GMS_BIN_DIR)"); \
        require "gmps_lib.pl"; \
        @ret = &get_target_path("$(1)"); \
        if ($$ret[0] ne "not found"){ \
            if ("type" eq "$(2)") {print $$ret[1];} \
            elsif ("src" eq "$(2)") {print $$ret[2];} \
            elsif ("build" eq "$(2)") {print $$ret[3];} \
            elsif ("out" eq "$(2)") {print $$ret[4];} \
            elsif ("all" eq "$(2)") {print "@ret";} \
        } else { \
            print $$ret[0]; \
        } \
        ')
endef
define get_flags_global
    $(shell perl -e '$$config_path="$(dir $(GMS_CONFIG))"; \
        $$GMPS_TOP="$(GMPS_TOP)"; \
        push(@INC,"$(GMS_BIN_DIR)"); \
        require "gmps_lib.pl"; \
        @ret = &get_flags_global("\@$(1)","\@$(2)"); \
        print "@ret"; \
        ')
endef


# example: get common flags/definations from gms_config with awk
CCACHE     := $(shell $(AWK) -v top="$(GMPS_TOP)" \
              '/CCACHE_PATH[ \t]/{gsub(/GMPS_TOP/, top, $$2); print $$2}' $(GMS_CONFIG))
CCACHE     := $(shell echo $(CCACHE)|cut -b 2-)
CC         := $(shell $(AWK) -v top="$(GMPS_TOP)" \
              '/CC_PATH[ \t]/{gsub(/GMPS_TOP/, top, $$NF); print $$NF}' $(GMS_CONFIG))
CC         := $(CCACHE) $(shell echo $(CC)|cut -b 2-)
LD         := $(shell $(AWK) -v top="$(GMPS_TOP)" \
              '/LD_PATH[ \t]/{gsub(/GMPS_TOP/, top, $$NF); print $$NF}' $(GMS_CONFIG))
LD         := $(CCACHE) $(shell echo $(LD)|cut -b 2-)

ifeq ($(BUILD_MODE), debug)
    GCCFLAGS_MODE = GCCFLAGS_REL64
    GLDFLAGS_MODE = GLDFLAGS_REL
    GLDFLAGS_MODE2 = GLDFLAGS_REL64
else
    GCCFLAGS_MODE = GCCFLAGS_DEB64
    GLDFLAGS_MODE = GLDFLAGS_DEB
    GLDFLAGS_MODE2 = GLDFLAGS_DEB64
endif

CCflags    += $(call get_flags_global,flags_global,GCINCS)
CCflags    += $(call get_flags_global,flags_global,GCCINCS)
CCflags    += $(call get_flags_global,flags_global,GCCFLAGS)
CCflags    += $(call get_flags_global,flags_global,GCCFLAGS64)
CCflags    += $(call get_flags_global,flags_global,$(GCCFLAGS_MODE))

LDflags    += $(call get_flags_global,flags_global,GLDFLAGS64)
LDflags    += $(call get_flags_global,flags_global,$(GLDFLAGS_MODE))
LDflags    += $(call get_flags_global,flags_global,$(GLDFLAGS_MODE2))

lib%: TARGET_CONFIG =$(strip $(call get_target_path,$@,all))
lib%: TYPE =$(word 2,$(TARGET_CONFIG))
lib%: SOURCE_DIR =$(word 3,$(TARGET_CONFIG))
lib%: BUILD_DIR =$(word 4,$(TARGET_CONFIG))/$(GMPS_ARCH)/$(BUILD_MODE)
lib%: OUT_DIR =$(word 5,$(TARGET_CONFIG))/$(GMPS_ARCH)/$(BUILD_MODE)
# Just for example <---------- END
endif

endif

include $(ADMIN_DIR)/make/project.mk

