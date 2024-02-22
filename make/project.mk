# project.mk - cyrus make tools
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
#################################
# target type enumeration: exe/lib/slib/ngg/java/pkg
#
# format: (without whitesapce between words)
# $(eval $(call SET_TARGET,_target_,_type_,_srcdir_,_dodir_,_dotargetdir_,_releasedir_)
#
# It's ok for adding target configurations that have not yet been implemented,
# top makefile will filtering and organizing and sorting target definations.
#################################

define SET_TARGET
TARGET_ALL      += $(1)
$(1)_type       := $(2)
$(1)_srcdir     := $(3)
#$(1)_builddir   := $(4)/$(BUILD_ARCH)/$(BUILD_MODE)
#$(1)_outdir     := $(5)/$(BUILD_ARCH)/$(BUILD_MODE)
#$(1)_reldir     := $(6)
$(1): override TYPE      := $(2)
$(1): override SOURCE_DIR:= $(3)
$(1): override BUILD_DIR := $(4)/$(BUILD_ARCH)/$(BUILD_MODE)
$(1): override OUT_DIR   := $(5)/$(BUILD_ARCH)/$(BUILD_MODE)
$(1): override REL_DIR   := $(6)
endef

define SET_TARGET_SPEC
$(1): override TYPE      := $(2)
$(1): override SOURCE_DIR:= $(3)
$(1): override BUILD_DIR := $(4)/$(BUILD_ARCH)/$(BUILD_MODE)
$(1): override OUT_DIR   := $(5)/$(BUILD_ARCH)/$(BUILD_MODE)
$(1): override REL_DIR   := $(6)
endef

#ifeq ($(CONFIG_MK_INCLUDED),)
#CONFIG_MK_INCLUDED := Y

$(eval $(call SET_TARGET,libt1,slib,$(PROJ_TOP)/example/t1,$(PROJ_TOP)/build/example/t1,$(PROJ_TOP)/build/lib,$(PROJ_TOP)/build/release))
$(eval $(call SET_TARGET,libt2,lib,$(PROJ_TOP)/example/t2,$(PROJ_TOP)/build/example/t2,$(PROJ_TOP)/build/lib,$(PROJ_TOP)/build/release))
$(eval $(call SET_TARGET,t3,exe,$(PROJ_TOP)/example/t3,$(PROJ_TOP)/build/example/t3,$(PROJ_TOP)/build/lib,$(PROJ_TOP)/build/release))
$(eval $(call SET_TARGET,pkg-abc,pkg,$(PROJ_TOP)/hss1/pkg/IMSabc,$(PROJ_TOP)/build/hss1/pkg/pkg-IMSabc,$(PROJ_TOP)/build/pkg,$(PROJ_TOP)/build/release/pkg))
$(eval $(call SET_TARGET,ngg-abc,ngg,$(PROJ_TOP)/hss1/pkg/IMSabc,$(PROJ_TOP)/build/hss1/pkg/pkg-IMSabc,$(PROJ_TOP)/build/pkg,$(PROJ_TOP)/build/release/pkg))
$(eval $(call SET_TARGET,java-abc,java,$(PROJ_TOP)/hss1/pkg/IMSabc,$(PROJ_TOP)/build/hss1/pkg/pkg-IMSabc,$(PROJ_TOP)/build/pkg,$(PROJ_TOP)/build/release/pkg))
# add target config in there













# target check and classify
FILTER_FUNC   = $(sort $(foreach sub,$(TARGET_ALL),$(if $(filter $(1),$($(sub)_type)), $(sub))))
TARGET_ALL_MK := $(sort $(foreach sub,$(TARGET_ALL),$(wildcard $($(sub)_srcdir)/$(sub).mk)))
TARGET_ALL    := $(foreach sub,$(TARGET_ALL_MK),$(basename $(notdir $(sub))))
TARGET_LIB    := $(call FILTER_FUNC,lib)
TARGET_SLIB   := $(call FILTER_FUNC,slib)
TARGET_EXE    := $(call FILTER_FUNC,exe)
TARGET_GO     := $(call FILTER_FUNC,ngg)
TARGET_JAVA   := $(call FILTER_FUNC,java)
TARGET_PKG    := $(call FILTER_FUNC,pkg)
#endif

