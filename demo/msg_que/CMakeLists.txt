project(msg_que)

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

include_directories(
    ${CMAKE_SOURCE_DIR}/3rdparty)

file(GLOB SRC_FILES ./*.cpp)
file(GLOB HEAD_FILES ./*.h)

add_executable(${PROJECT_NAME} ${SRC_FILES} ${HEAD_FILES})

add_dependencies(${PROJECT_NAME} libipc)
target_link_libraries(${PROJECT_NAME} libipc)