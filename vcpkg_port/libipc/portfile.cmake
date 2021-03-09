vcpkg_fail_port_install(ON_ARCH "arm" "arm64" ON_TARGET "UWP")

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO winsoft666/cpp-ipc
    REF f495130520a6712fa1ca3fb8be24c683146a6ab4
    SHA512 4f6633b6e2df6d1b37e9bcaf5a4c09df0c249f61a7c152f4292133aefd7f755f44b40e1e8f44c6288bcaeeb2603c98feab35c3ba3fd1434bed7378caef7183ba
    HEAD_REF master
)

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "static" __IPC_STATIC__)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
	PREFER_NINJA
    OPTIONS
        -D__IPC_STATIC__:BOOL=${__IPC_STATIC__}
        -DBUILD_TESTS:BOOL=OFF
)

vcpkg_install_cmake()

if(EXISTS ${CURRENT_PACKAGES_DIR}/lib/cmake/cpp-ipc)
    vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/cpp-ipc)
elseif(EXISTS ${CURRENT_PACKAGES_DIR}/share/cpp-ipc)
    vcpkg_fixup_cmake_targets(CONFIG_PATH share/cpp-ipc)
endif()

file(READ ${CURRENT_PACKAGES_DIR}/include/libipc/export.h LIBIPC_EXPORT_H)
if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    string(REPLACE "#ifdef __IPC_STATIC__" "#if 1" LIBIPC_EXPORT_H "${LIBIPC_EXPORT_H}")
else()
    string(REPLACE "#ifdef __IPC_STATIC__" "#if 0" LIBIPC_EXPORT_H "${LIBIPC_EXPORT_H}")
endif()
file(WRITE ${CURRENT_PACKAGES_DIR}/include/libipc/export.h "${LIBIPC_EXPORT_H}")

file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

vcpkg_copy_pdbs()
