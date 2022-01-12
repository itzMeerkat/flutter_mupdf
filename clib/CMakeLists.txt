cmake_minimum_required(VERSION 3.22)

project(flutter_mupdf)

add_library(flutter_mupdf SHARED "./libmypdf.cc" "./libmypdf.def")

include_directories("C:/Users/admin/workspace/mupdf-1.19.0-source/mupdf-1.19.0-source/include")
target_link_libraries(flutter_mupdf PUBLIC "C:/Users/admin/workspace/mupdf-1.19.0-source/mupdf-1.19.0-source/platform/win32/x64/Debug/libmupdf.lib")
