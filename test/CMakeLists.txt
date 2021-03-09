project(test-ipc)

if(NOT BUILD_SHARED_LIBS)
	add_compile_options(-D__IPC_STATIC__)
endif()

if (MSVC AND USE_STATIC_CRT)
    set(CompilerFlags
        CMAKE_CXX_FLAGS
        CMAKE_CXX_FLAGS_DEBUG
        CMAKE_CXX_FLAGS_RELEASE
        CMAKE_C_FLAGS
        CMAKE_C_FLAGS_DEBUG
        CMAKE_C_FLAGS_RELEASE
        )
    foreach(CompilerFlag ${CompilerFlags})
        string(REPLACE "/MD" "/MT" ${CompilerFlag} "${${CompilerFlag}}")
    endforeach()
endif()

if(NOT MSVC)
  add_compile_options(
    -Wno-attributes 
    -Wno-missing-field-initializers 
    -Wno-unused-variable 
    -Wno-unused-function)
endif()

include_directories(
    ${CMAKE_SOURCE_DIR}/include 
    ${CMAKE_SOURCE_DIR}/src
    ${CMAKE_SOURCE_DIR}/test
    ${CMAKE_SOURCE_DIR}/3rdparty)

file(GLOB SRC_FILES  ${CMAKE_SOURCE_DIR}/test/*.cpp)
file(GLOB HEAD_FILES ${CMAKE_SOURCE_DIR}/test/*.h)

add_executable(${PROJECT_NAME} ${SRC_FILES} ${HEAD_FILES})

find_package(GTest MODULE REQUIRED)
target_link_libraries(${PROJECT_NAME} GTest::GTest GTest::Main)

link_directories(${CMAKE_SOURCE_DIR}/3rdparty/gperftools)
#target_link_libraries(${PROJECT_NAME} tcmalloc_minimal)

add_test(NAME unit
COMMAND ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR}/unit_tests)

if(BUILD_SHARED_LIBS)
	add_dependencies(${PROJECT_NAME} libipc)
	
	target_link_libraries(${PROJECT_NAME} 
		$<TARGET_LINKER_FILE:libipc> )
else()
	add_dependencies(${PROJECT_NAME} libipc)
	
	target_link_libraries(${PROJECT_NAME} 
		$<TARGET_LINKER_FILE:libipc> )
endif()
