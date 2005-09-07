# This file sets the basic flags for the C++ language in CMake.
# It also loads the available platform file for the system-compiler
# if it exists.


GET_FILENAME_COMPONENT(CMAKE_BASE_NAME ${CMAKE_CXX_COMPILER} NAME_WE)
# since the gnu compiler has several names force g++
IF(CMAKE_COMPILER_IS_GNUCXX)
  SET(CMAKE_BASE_NAME g++)
ENDIF(CMAKE_COMPILER_IS_GNUCXX)
SET(CMAKE_SYSTEM_AND_CXX_COMPILER_INFO_FILE
  ${CMAKE_ROOT}/Modules/Platform/${CMAKE_SYSTEM_NAME}-${CMAKE_BASE_NAME}.cmake)
INCLUDE(Platform/${CMAKE_SYSTEM_NAME}-${CMAKE_BASE_NAME} OPTIONAL)

# for most systems a module is the same as a shared library
# so unless the variable CMAKE_MODULE_EXISTS is set just
# copy the values from the LIBRARY variables
IF(NOT CMAKE_MODULE_EXISTS)
  SET(CMAKE_SHARED_MODULE_CXX_FLAGS ${CMAKE_SHARED_LIBRARY_CXX_FLAGS})
ENDIF(NOT CMAKE_MODULE_EXISTS)
# Create a set of shared library variable specific to C++
# For 90% of the systems, these are the same flags as the C versions
# so if these are not set just copy the flags from the c version
IF(NOT CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS)
  SET(CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS ${CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS})
ENDIF(NOT CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS)

IF(NOT CMAKE_SHARED_LIBRARY_CXX_FLAGS)
  SET(CMAKE_SHARED_LIBRARY_CXX_FLAGS ${CMAKE_SHARED_LIBRARY_C_FLAGS})
ENDIF(NOT CMAKE_SHARED_LIBRARY_CXX_FLAGS)

IF(NOT CMAKE_SHARED_LIBRARY_LINK_CXX_FLAGS)
  SET(CMAKE_SHARED_LIBRARY_LINK_CXX_FLAGS ${CMAKE_SHARED_LIBRARY_LINK_C_FLAGS})
ENDIF(NOT CMAKE_SHARED_LIBRARY_LINK_CXX_FLAGS)

IF(NOT CMAKE_SHARED_LIBRARY_RUNTIME_CXX_FLAG)
  SET(CMAKE_SHARED_LIBRARY_RUNTIME_CXX_FLAG ${CMAKE_SHARED_LIBRARY_RUNTIME_C_FLAG}) 
ENDIF(NOT CMAKE_SHARED_LIBRARY_RUNTIME_CXX_FLAG)

IF(NOT CMAKE_SHARED_LIBRARY_RUNTIME_CXX_FLAG_SEP)
  SET(CMAKE_SHARED_LIBRARY_RUNTIME_CXX_FLAG_SEP ${CMAKE_SHARED_LIBRARY_RUNTIME_C_FLAG_SEP})
ENDIF(NOT CMAKE_SHARED_LIBRARY_RUNTIME_CXX_FLAG_SEP)

IF(NOT CMAKE_INCLUDE_FLAG_CXX)
  SET(CMAKE_INCLUDE_FLAG_CXX ${CMAKE_INCLUDE_FLAG_C})
ENDIF(NOT CMAKE_INCLUDE_FLAG_CXX)

IF(NOT CMAKE_INCLUDE_FLAG_SEP_CXX)
  SET(CMAKE_INCLUDE_FLAG_SEP_CXX ${CMAKE_INCLUDE_FLAG_SEP_C})
ENDIF(NOT CMAKE_INCLUDE_FLAG_SEP_CXX)

# repeat for modules
IF(NOT CMAKE_SHARED_MODULE_CREATE_CXX_FLAGS)
  SET(CMAKE_SHARED_MODULE_CREATE_CXX_FLAGS ${CMAKE_SHARED_MODULE_CREATE_C_FLAGS})
ENDIF(NOT CMAKE_SHARED_MODULE_CREATE_CXX_FLAGS)

IF(NOT CMAKE_SHARED_MODULE_CXX_FLAGS)
  SET(CMAKE_SHARED_MODULE_CXX_FLAGS ${CMAKE_SHARED_MODULE_C_FLAGS})
ENDIF(NOT CMAKE_SHARED_MODULE_CXX_FLAGS)

IF(NOT CMAKE_SHARED_MODULE_LINK_CXX_FLAGS)
  SET(CMAKE_SHARED_MODULE_LINK_CXX_FLAGS ${CMAKE_SHARED_MODULE_LINK_C_FLAGS})
ENDIF(NOT CMAKE_SHARED_MODULE_LINK_CXX_FLAGS)

IF(NOT CMAKE_SHARED_MODULE_RUNTIME_CXX_FLAG)
  SET(CMAKE_SHARED_MODULE_RUNTIME_CXX_FLAG ${CMAKE_SHARED_MODULE_RUNTIME_FLAG}) 
ENDIF(NOT CMAKE_SHARED_MODULE_RUNTIME_CXX_FLAG)

IF(NOT CMAKE_SHARED_MODULE_RUNTIME_CXX_FLAG_SEP)
  SET(CMAKE_SHARED_MODULE_RUNTIME_CXX_FLAG_SEP ${CMAKE_SHARED_MODULE_RUNTIME_FLAG_SEP})
ENDIF(NOT CMAKE_SHARED_MODULE_RUNTIME_CXX_FLAG_SEP)

# add the flags to the cache based
# on the initial values computed in the platform/*.cmake files
# use _INIT variables so that this only happens the first time
# and you can set these flags in the cmake cache
SET (CMAKE_CXX_FLAGS "$ENV{CXXFLAGS} ${CMAKE_CXX_FLAGS_INIT}" CACHE STRING
     "Flags used by the compiler during all build types.")


IF(NOT CMAKE_NOT_USING_CONFIG_FLAGS)
  SET (CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG_INIT}" CACHE STRING
     "Flags used by the compiler during debug builds.")
  SET (CMAKE_CXX_FLAGS_MINSIZEREL "${CMAKE_CXX_FLAGS_MINSIZEREL_INIT}" CACHE STRING
      "Flags used by the compiler during release minsize builds.")
  SET (CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE_INIT}" CACHE STRING
     "Flags used by the compiler during release builds (/MD /Ob1 /Oi /Ot /Oy /Gs will produce slightly less optimized but smaller files).")
  SET (CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO_INIT}" CACHE STRING
     "Flags used by the compiler during Release with Debug Info builds.")

ENDIF(NOT CMAKE_NOT_USING_CONFIG_FLAGS)


INCLUDE(CMakeCommonLanguageInclude)

# now define the following rules:
# CMAKE_CXX_CREATE_SHARED_LIBRARY
# CMAKE_CXX_CREATE_SHARED_MODULE
# CMAKE_CXX_CREATE_STATIC_LIBRARY
# CMAKE_CXX_COMPILE_OBJECT
# CMAKE_CXX_LINK_EXECUTABLE

# variables supplied by the generator at use time
# <TARGET>
# <TARGET_BASE> the target without the suffix
# <OBJECTS>
# <OBJECT>
# <LINK_LIBRARIES>
# <FLAGS>
# <LINK_FLAGS>

# CXX compiler information
# <CMAKE_CXX_COMPILER>  
# <CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS>
# <CMAKE_CXX_SHARED_MODULE_CREATE_FLAGS>
# <CMAKE_CXX_LINK_FLAGS>

# Static library tools
# <CMAKE_AR> 
# <CMAKE_RANLIB>


# create a shared C++ library
IF(NOT CMAKE_CXX_CREATE_SHARED_LIBRARY)
  SET(CMAKE_CXX_CREATE_SHARED_LIBRARY
      "<CMAKE_CXX_COMPILER> <CMAKE_SHARED_LIBRARY_CXX_FLAGS> <LINK_FLAGS> <CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS> <CMAKE_SHARED_LIBRARY_SONAME_CXX_FLAG><TARGET_SONAME> -o <TARGET> <OBJECTS> <LINK_LIBRARIES>")
ENDIF(NOT CMAKE_CXX_CREATE_SHARED_LIBRARY)

IF(CMAKE_COMPILER_IS_GNUCXX)
  SET(CMAKE_CXX_CREATE_SHARED_LIBRARY "${CMAKE_CXX_CREATE_SHARED_LIBRARY} -lgcc")
ENDIF(CMAKE_COMPILER_IS_GNUCXX)

# create a c++ shared module copy the shared library rule by default
IF(NOT CMAKE_CXX_CREATE_SHARED_MODULE)
  SET(CMAKE_CXX_CREATE_SHARED_MODULE ${CMAKE_CXX_CREATE_SHARED_LIBRARY})
ENDIF(NOT CMAKE_CXX_CREATE_SHARED_MODULE)


# create a C++ static library
IF(NOT CMAKE_CXX_CREATE_STATIC_LIBRARY)
  SET(CMAKE_CXX_CREATE_STATIC_LIBRARY
      "<CMAKE_AR> cr <TARGET> <LINK_FLAGS> <OBJECTS> "
      "<CMAKE_RANLIB> <TARGET> ")
ENDIF(NOT CMAKE_CXX_CREATE_STATIC_LIBRARY)

# compile a C++ file into an object file
IF(NOT CMAKE_CXX_COMPILE_OBJECT)
  SET(CMAKE_CXX_COMPILE_OBJECT
    "<CMAKE_CXX_COMPILER>  <FLAGS> -o <OBJECT> -c <SOURCE>")
ENDIF(NOT CMAKE_CXX_COMPILE_OBJECT)

IF(NOT CMAKE_CXX_LINK_EXECUTABLE)
  SET(CMAKE_CXX_LINK_EXECUTABLE
    "<CMAKE_CXX_COMPILER>  <FLAGS> <CMAKE_CXX_LINK_FLAGS> <LINK_FLAGS> <OBJECTS>  -o <TARGET> <LINK_LIBRARIES>")
ENDIF(NOT CMAKE_CXX_LINK_EXECUTABLE)

MARK_AS_ADVANCED(
CMAKE_BUILD_TOOL
CMAKE_VERBOSE_MAKEFILE 
CMAKE_CXX_FLAGS
CMAKE_CXX_FLAGS_RELEASE
CMAKE_CXX_FLAGS_RELWITHDEBINFO
CMAKE_CXX_FLAGS_MINSIZEREL
CMAKE_CXX_FLAGS_DEBUG)

SET(CMAKE_CXX_INFOMATION_LOADED 1)

