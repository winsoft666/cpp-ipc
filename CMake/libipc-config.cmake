# libipc-config.cmake - package configuration file

get_filename_component(SELF_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)

if(EXISTS ${SELF_DIR}/libipc-target.cmake)
	include(${SELF_DIR}/libipc-target.cmake)
endif()

if(EXISTS ${SELF_DIR}/libipc-static-target.cmake)
	include(${SELF_DIR}/libipc-static-target.cmake)
endif()
