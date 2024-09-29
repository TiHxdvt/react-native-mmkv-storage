# the minimum version of CMake.
cmake_minimum_required(VERSION 3.14)
set(CMAKE_VERBOSE_MAKEFILE on)

file(GLOB rnoh_mmkv_SRC CONFIGURE_DEPENDS
 *.cpp
 ${CMAKE_CURRENT_SOURCE_DIR}/*.cpp
 ${CMAKE_CURRENT_SOURCE_DIR}/Core/*.cpp
 ${CMAKE_CURRENT_SOURCE_DIR}/Core/aes/*.cpp
 ${CMAKE_CURRENT_SOURCE_DIR}/Core/aes/openssl/*.cpp
 ${CMAKE_CURRENT_SOURCE_DIR}/Core/crc32/*.cpp
 ${CMAKE_CURRENT_SOURCE_DIR}/Core/crc32/zlib/*.cpp
)
add_library(rnoh_mmkv_storage SHARED ${rnoh_mmkv_SRC})


target_include_directories(rnoh_mmkv_storage PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_include_directories(rnoh_mmkv_storage PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/Core)

target_link_libraries(rnoh_mmkv_storage PUBLIC rnoh)
target_link_libraries(rnoh_mmkv_storage PUBLIC libace_napi.z.so)

target_link_libraries(rnoh_mmkv_storage PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/Core/libs/arm64-v8a/libmmkv.so)