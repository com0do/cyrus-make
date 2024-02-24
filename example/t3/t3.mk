

CCFLAGS  +=  \
    -I$(PROJ_TOP)/example/t1/include \
    -I$(PROJ_TOP)/example/t2/include \
    -DBASE64_WITH_INITIALIZATION

CXXSOURCE += t3.cxx
LDLIBS    += -lcrypto -lt1 -lt2

LDFLAGS  += -L$(OUT_DIR)




# always place in end of file
include $(PROJ_TOP)/make/target.c.mk
