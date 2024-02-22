

CCFLAGS  +=  \
    -I$(PROJ_TOP)/example/t2/include \
    -DBASE64_WITH_INITIALIZATION

vpath %.cxx $(PROJ_TOP)/example/t2/src

CXXSOURCE += t2.cxx

LDFLAGS  += -L$(PROJ_TOP)/tools/rhlinux/usr/lib64





# always place in end of file
include $(PROJ_TOP)/make/target.mk
