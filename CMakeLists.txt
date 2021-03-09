cmake_minimum_required(VERSION 3.10)
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/CMake;${CMAKE_MODULE_PATH}")
project(cpp-ipc)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -DNDEBUG")
if(NOT MSVC)
  set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O2")
endif()

include_directories(${CMAKE_SOURCE_DIR}/include)

option(BUILD_SHARED_LIBS "Build shared libraries" ON)
option(BUILD_TESTS "Build tests project" OFF)
option(USE_STATIC_CRT "Set to ON to build with static CRT on Windows (/MT)." OFF)

set(DEBUG_LIBNAME_SUFFIX "-d" 
	CACHE STRING "Optional suffix to append to the library name for a debug build")
mark_as_advanced(DEBUG_LIBNAME_SUFFIX)

set(LIBRARY_OUTPUT_PATH    ${CMAKE_BINARY_DIR}/bin)
set(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR}/bin)

if(WIN32)
	# Dll default use MD(d), Lib default use MT(d)
	if(BUILD_SHARED_LIBS)
		set(USE_STATIC_CRT OFF)
	else()
		set(USE_STATIC_CRT ON)
	endif()
endif()

if(MSVC)
  set(LIBIPC_INSTALL_CMAKE_DIR share/libipc)
elseif(WIN32 AND NOT CYGWIN)
  set(LIBIPC_INSTALL_CMAKE_DIR CMake)
else()
  set(LIBIPC_INSTALL_CMAKE_DIR lib/cmake/libipc)
endif()

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# Unicode Support
add_definitions(-DUNICODE -D_UNICODE)

set_property(GLOBAL PROPERTY USE_FOLDERS ON)

add_subdirectory(src)

if(BUILD_TESTS)
	add_subdirectory(test)

	add_subdirectory(demo/chat)
	add_subdirectory(demo/msg_que)
	
	enable_testing()
endif()