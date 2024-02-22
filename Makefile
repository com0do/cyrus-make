# Makefile - cyrus make tools
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



include $(CURDIR)/make/rules.mk

# config
DEP_DERIVATION_PARALLEL := 0


# target check
ifeq ($(o),clean)
SUB_TARGET := clean
else ifeq ($(o),check)
SUB_TARGET := check
endif

TARGET_DEP := $(CURDIR)/make/depend.mk
ifneq ($(MAKECMDGOALS),dep)
-include $(TARGET_DEP)
endif

ifneq ($(filter lib%,$(MAKECMDGOALS)),)
ifneq ($(filter pkg%,$(MAKECMDGOALS)),)
$(error ERROR: Do not mix lib and pkg target)
endif
endif


all:  $(TARGET_ALL)
dep:  DRY_RUN := 1
clean:SUB_TARGET := clean
clean:$(TARGET_ALL)
.PRECIOUS: $(TARGET_DEP)
.PHONY: all dep clean

# automatic dependence derivation
ifeq ($(MAKELEVEL), 0)
$(TARGET_DEP): $(TARGET_ALL_MK)
ifeq ($(DEP_DERIVATION_PARALLEL),1)
	@$(MAKE) $(foreach sub,$?,$(basename $(notdir $(sub)))) DRY_RUN=1
else
	@for sub in $? ;do $(MAKE) $$(basename $$sub .mk) DRY_RUN=1 ;done
endif
	@sort -o $(TARGET_DEP) $(TARGET_DEP)
endif



# general recipe
dep: $(TARGET_ALL)
	@sort -o $(TARGET_DEP) $(TARGET_DEP)
$(TARGET_ALL):
	@[ "$(SOURCE_DIR)" != "not found" ] && $(MAKE) -C $(SOURCE_DIR) -f $@.mk $(SUB_TARGET) \
	|| (echo "Is $(SOURCE_DIR)/$@.mk OK ?";exit 1)






