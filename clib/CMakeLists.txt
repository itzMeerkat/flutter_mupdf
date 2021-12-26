project(flutter_mupdf)

add_library(flutter_mupdf SHARED "./libmypdf.cc" "./libmypdf.def")

include_directories("C:/Users/bbfag/workspace/mupdf/include")
target_link_libraries(flutter_mupdf PUBLIC "C:/Users/bbfag/workspace/mupdf/platform/win32/x64/Release/libmupdf.lib")