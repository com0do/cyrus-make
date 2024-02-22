# variable.mk - cyrus make tools
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
# common debug/release compilation/link flag
# change to your personal definations
#
########################################################################


#ifeq ($(MAKELEVEL), 0)
ifeq ($(VARIABLE_MK_INCLUDED),)
VARIABLE_MK_INCLUDED := Y

OS_TYPE := Rocky
C_PATH  := $(firstword $(wildcard $(PROJ_TOP)/tools/rhlinux/gcc/bin/gcc $(CC) /usr/bin/gcc))
CC_PATH := $(firstword $(wildcard $(PROJ_TOP)/tools/rhlinux/gcc/bin/g++ $(CPP) /usr/bin/g++))
LD_PATH := $(firstword $(wildcard $(PROJ_TOP)/tools/rhlinux/gcc/bin/g++ $(CPP) /usr/bin/g++))
CCACHE_PATH := $(firstword $(wildcard $(PROJ_TOP)/tools/ccache-4.8/ccache /usr/bin/ccache))

# C/C++ program include flags
GCINCS +=   -I$(PROJ_TOP)/common/inc \
            -I$(PROJ_TOP)/common/inc_blr

# C program flags
GCINCSUSR +=-I$(PROJ_TOP)/tools/rhlinux/usr/include
# C++ program flags
GCCINCS +=  -I$(PROJ_TOP)/common/nem/include \
            -I$(PROJ_TOP)/tools/rhlinux/usr/include \
            -I$(PROJ_TOP)/tools/rhlinux/solid

CC_INCLUDES += $(GCINCS) $(GCCINCS)
C_INCLUDES  += $(GCINCS) $(GCINCSUSR)


GCFLAGS         += -fPIC -DLINUX -DHSS_NODE
GCFLAGS64       += -DRTP_64BIT
GCFLAGS_DEB     += -g -DDEBUG
GCFLAGS_DEB64   += -m64
GCFLAGS_REL64   += -m64
GCFLAGS_REL     +=
C_FLAGS_Debug   += $(GCFLAGS64) $(GCFLAGS_DEB) $(GCFLAGS_DEB64)
C_FLAGS_Release += $(GCFLAGS64) $(GCFLAGS_REL) $(GCFLAGS_REL64)


GCCFLAGS += -fPIC -DLINUX -D_REENTRANT -D_POSIX_PTHREAD_SEMANTICS -DNM_NOT_CONFIGURED  -std=c++11
GCCFLAGS64 += -DRTP_64BIT -Wall -Wno-conversion -Wno-sign-conversion -Wno-reorder -DHSS_NODE -O2
GCCFLAGS_DEB64 += -m64
GCCFLAGS_REL64 += -m64
GCCFLAGS_DEB += -g -DDEBUG
GCCFLAGS_REL +=
CC_FLAGS_Debug += $(GCCFLAGS64) $(GCCFLAGS_DEB) $(GCCFLAGS_DEB64)
CC_FLAGS_Release += $(GCCFLAGS64) $(GCCFLAGS_REL) $(GCCFLAGS_REL64)



GLDFLAGS64 += -Wl,-rpath-link,$(PROJ_TOP)/tools/icm/lib
GLDFLAGS64 += -Wl,-rpath-link,$(PROJ_TOP)/cmrepo/lib
GLDFLAGS64 += -Wl,-rpath-link,$(PROJ_TOP)/tools/openssl
GLDFLAGS64 += -Wl,-rpath-link,$(PROJ_TOP)/common/tools/boost_1_57_0/lib
GLDFLAGS64 += -L$(PROJ_TOP)/tools/rhlinux/lib64
GLDFLAGS64 += -L$(PROJ_TOP)/tools/rhlinux/usr/lib64
GLDFLAGS64 += -Wl,-rpath-link,$(PROJ_TOP)/tools/icm/lib64
GLDFLAGS64 += -Wl,-rpath-link,$(PROJ_TOP)/cmrepo/lib64
GLDFLAGS64 += -Wl,-rpath-link,$(PROJ_TOP)/tools/rhlinux/usr/lib64
GLDFLAGS64 += -std=c++11 
GLDFLAGS_DEB   += -g -L$(PROJ_TOP)/builld/lib/rhlinux/debug
GLDFLAGS_DEB64 += -O2 -m64
GLDFLAGS_REL   += -L$(PROJ_TOP)/build/lib/rhlinux/release
GLDFLAGS_REL64 += -O2 -m64
LD_FLAGS_Debug += $(GLDFLAGS64) $(GLDFLAGS_DEB) $(GLDFLAGS_DEB64)
LD_FLAGS_Release += $(GLDFLAGS64) $(GLDFLAGS_REL) $(GLDFLAGS_REL64)


# output settings
CCACHE := $(CCACHE_PATH)
C      := $(CCACHE) $(C_PATH)
CC     := $(CCACHE) $(CC_PATH)
LD     := $(CCACHE) $(LD_PATH)
CCflags += $(CC_INCLUDES) $(GCCFLAGS)
Cflags += $(C_INCLUDES) $(GCFLAGS)
ifeq ($(BUILD_MODE), debug)
Cflags += $(C_FLAGS_Debug)
CCflags += $(CC_FLAGS_Debug)
LDflags += $(LD_FLAGS_Debug)
else
Cflags += $(C_FLAGS_Release)
CCflags += $(CC_FLAGS_Release)
LDflags += $(LD_FLAGS_Release)
endif

endif
