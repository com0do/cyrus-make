
# auto-dependence-deduced with raw make syntax


## feature

- easy usage
- auto deduced dependence
- use raw makefile syntax
- easy to write sub-target's makefile

## usage


|---------------------|----------------------------------|
| command             | meanings                         |
|---------------------|----------------------------------|
| make                | build all target                 |
| make dep            | produce target dependence        |
| make libxxx         | build target                     |
| make libxxx o=clean | clean target output              |
| make libxxx o=check | check target compilation command |
|---------------------|----------------------------------|


## customization step

only need 2 steps:
- create you sub-target source  file and target makefile with named TARGET.mk
- add configuration in make/project.mk


## installation
simple clone repo with git, support single repo and multiple repo 


## example usage
automatical generate dependence file make/depend.mk and update dependence relationships,
then do compilation and get right result.
```shell
make t3
```

## sub-target's makefile variables supported
- CCFLAGS
- CFLAGS
- vpath
- CXXSOURCE
- CSOURCE
- LDLIBS
- LDFLAGS
- LIB_NAME
- AR_NAME
- BIN_NAME



## TODO
- porting lcov for coverage , easy checkout coverage for every single commitment.
- be compatibe with other target type 
- add an automatical header file generator
  
