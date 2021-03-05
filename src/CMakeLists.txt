project(libipc)

if(BUILD_SHARED_LIBS)
	add_compile_options(-D__IPC_LIBRARY__)
else()
	add_compile_options(-D__IPC_STATIC__)
endif()

if(NOT MSVC)
  add_compile_options(-fPIC)
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
    ${CMAKE_SOURCE_DIR}/include 
    ${CMAKE_SOURCE_DIR}/src)
	
file(GLOB BASE_HEADER_FILES 	../include/libipc/*.h)

if(UNIX)
  file(GLOB SRC_FILES ${CMAKE_SOURCE_DIR}/src/libipc/platform/*_linux.cpp)
else()
  file(GLOB SRC_FILES ${CMAKE_SOURCE_DIR}/src/libipc/platform/*_win.cpp)
endif()
aux_source_directory(${CMAKE_SOURCE_DIR}/src SRC_FILES)

file(GLOB HEAD_FILES
  ${BASE_HEADER_FILES}
  ${CMAKE_SOURCE_DIR}/src/libipc/*.h
  ${CMAKE_SOURCE_DIR}/src/libipc/*.inc
  ${CMAKE_SOURCE_DIR}/src/libipc/circ/*.h
  ${CMAKE_SOURCE_DIR}/src/libipc/memory/*.h
  ${CMAKE_SOURCE_DIR}/src/libipc/platform/*.h
  ${CMAKE_SOURCE_DIR}/src/libipc/utility/*.h)
  

if(BUILD_SHARED_LIBS) 
	add_library(${PROJECT_NAME} SHARED ${SRC_FILES} ${HEAD_FILES})
else()
	add_library(${PROJECT_NAME} STATIC ${SRC_FILES} ${HEAD_FILES})
	set_target_properties(libipc PROPERTIES 
		INTERFACE_COMPILE_DEFINITIONS __IPC_STATIC__)
endif()

if(NOT MSVC)
  target_link_libraries(${PROJECT_NAME} PUBLIC
      pthread
      $<$<NOT:$<STREQUAL:${CMAKE_SYSTEM_NAME},Windows>>:rt>)
endif()


# Set output directory
set_target_properties(libipc
	PROPERTIES
	ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
	LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
	RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin" )

target_include_directories(libipc INTERFACE
	$<INSTALL_INTERFACE:include>)


install(TARGETS libipc
	EXPORT libipc-target
	RUNTIME DESTINATION bin
	LIBRARY DESTINATION lib
	ARCHIVE DESTINATION lib)
	


install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/../CMake/libipc-config.cmake 
	DESTINATION ${LIBIPC_INSTALL_CMAKE_DIR})

install(FILES ${BASE_HEADER_FILES} 
	DESTINATION include/libipc)

export(TARGETS libipc
       APPEND FILE ${PROJECT_BINARY_DIR}/libipc-target.cmake
)

install(EXPORT libipc-target
        FILE libipc-target.cmake
        DESTINATION ${LIBIPC_INSTALL_CMAKE_DIR}
)

