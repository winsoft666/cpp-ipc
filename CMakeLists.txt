cmake_minimum_required(VERSION 3.10)
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

set(LIBRARY_OUTPUT_PATH    ${CMAKE_BINARY_DIR}/bin)
set(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR}/bin)

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

add_subdirectory(src)

if(BUILD_TESTS)
	set(GOOGLETEST_VERSION 1.10.0)
	add_subdirectory(3rdparty/gtest)
	add_subdirectory(test)

	add_subdirectory(demo/chat)
	add_subdirectory(demo/msg_que)
endif()