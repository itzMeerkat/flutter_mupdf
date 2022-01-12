cmake_minimum_required(VERSION 3.22)

project(libmupdf_wrapper)

add_library(libmupdf_wrapper SHARED "./mupdf_wrapper.cc" "./mupdf_wrapper.def")
if(MSVC)
    set_property(TARGET libmupdf_wrapper APPEND PROPERTY LINK_FLAGS "/NODEFAULTLIB:LIBCMTD")
endif()

include_directories("C:/Users/admin/workspace/mupdf-1.19.0-source/mupdf-1.19.0-source/include")
target_link_libraries(libmupdf_wrapper PUBLIC "C:/Users/admin/workspace/mupdf-1.19.0-source/mupdf-1.19.0-source/platform/win32/x64/Debug/libmupdf.lib")
