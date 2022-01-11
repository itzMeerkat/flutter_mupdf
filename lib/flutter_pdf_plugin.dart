import 'dart:ffi';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';
import 'package:flutter_pdf_plugin/pdf_text.dart';
import 'dart:io' show Directory, Platform;
import 'package:path/path.dart' as path;
import 'dart:convert';
import 'dart:ui';

typedef LoadDocumentFunc = int Function(Pointer<Utf8>);
typedef load_document_func = Int32 Function(Pointer<Utf8>);

typedef GetPageCountFunc = int Function(Pointer<Int32>);
typedef get_page_count = Int32 Function(Pointer<Int32>);

typedef GetPageTextFunc = int Function(
    int, Pointer<Pointer<Utf8>>, Pointer<Int32>);
typedef get_page_text = Int32 Function(
    Int32, Pointer<Pointer<Utf8>>, Pointer<Int32>);

typedef GetPagePixmapFunc = int Function(int, Pointer<Pointer<Uint8>>,
    Pointer<Int32>, Pointer<Int32>, Pointer<Int32>, Pointer<Int32>);
typedef get_page_pixmap = Int32 Function(Int32, Pointer<Pointer<Uint8>>,
    Pointer<Int32>, Pointer<Int32>, Pointer<Int32>, Pointer<Int32>);

typedef ClearMuPDFFunc = void Function();
typedef clear_mupdf = Void Function();

class FlutterPdfPlugin {
  String libraryPath =
      path.join(Directory.current.path, 'clib', 'Debug', 'flutter_mupdf.dll');
  LoadDocumentFunc? loadDocumentFunc;
  GetPageCountFunc? getPageCountFunc;
  GetPageTextFunc? getPageTextFunc;
  ClearMuPDFFunc? clearMuPDFFunc;
  GetPagePixmapFunc? getPagePixmapFunc;

  FlutterPdfPlugin() {
    final dylib = DynamicLibrary.open(libraryPath);
    loadDocumentFunc = dylib
        .lookup<NativeFunction<load_document_func>>('LoadDocument')
        .asFunction();

    getPageCountFunc = dylib
        .lookup<NativeFunction<get_page_count>>('GetPageCount')
        .asFunction();

    getPageTextFunc =
        dylib.lookup<NativeFunction<get_page_text>>('GetPageText').asFunction();

    clearMuPDFFunc =
        dylib.lookup<NativeFunction<clear_mupdf>>('ClearMuPDF').asFunction();

    getPagePixmapFunc = dylib
        .lookup<NativeFunction<get_page_pixmap>>('GetPagePixmap')
        .asFunction();
  }

  void loadDocument(String p) {
    var _p = p.toNativeUtf8();
    int suc = loadDocumentFunc!(_p);
    calloc.free(_p);
    if (suc > 0) {
      throw suc;
    }
  }

  int getPageCount() {
    Pointer<Int32> p = calloc<Int32>();
    var suc = getPageCountFunc!(p);
    int ret = p.value;
    calloc.free(p);
    return ret;
  }

  PdfText getPageText(int pageNumber) {
    Pointer<Pointer<Utf8>> j = calloc<Pointer<Utf8>>();
    Pointer<Int32> l = calloc<Int32>();
    getPageTextFunc!(pageNumber, j, l);
    String ret = j.value.toDartString(length: l.value);
    calloc.free(j);
    calloc.free(l);
    var d = jsonDecode(ret);
    return PdfText.fromJson(d);
  }

  Image? getPagePixmap(int pageNumber) {
    Pointer<Pointer<Uint8>> raw = calloc<Pointer<Uint8>>();
    Pointer<Int32> _w = calloc<Int32>();
    Pointer<Int32> _h = calloc<Int32>();
    Pointer<Int32> _stride = calloc<Int32>();
    Pointer<Int32> _channel = calloc<Int32>();
    getPagePixmapFunc!(pageNumber, raw, _w, _h, _stride, _channel);
    int w = _w.value;
    int h = _h.value;
    int stride = _stride.value;
    int channel = _channel.value;

    Uint8List rawPixel = raw.value.asTypedList(w * h * channel);
    Image? ret;
    decodeImageFromPixels(rawPixel, w, h, PixelFormat.rgba8888, (Image img) {
      ret = img;
    });
    return ret;
  }

  void clearMuPDF() {
    clearMuPDFFunc!();
  }
}
