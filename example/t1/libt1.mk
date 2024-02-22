

CCFLAGS  +=  \
    -I$(PROJ_TOP)/example/t1/include \
    -DBASE64_WITH_INITIALIZATION

vpath %.cxx $(PROJ_TOP)/example/t1/src
vpath %.c   $(PROJ_TOP)/example/t1/src
vpath %.cxx $(PROJ_TOP)/example/vpath/src
vpath %.c   $(PROJ_TOP)/example/vpath/src

CXXSOURCE += t1.cxx
CSOURCE   += t11.c
LDLIBS    += -lcrypto

LDFLAGS  += -L$(PROJ_TOP)/tools/rhlinux/usr/lib64





# always place in end of file
include $(PROJ_TOP)/make/target.mk
