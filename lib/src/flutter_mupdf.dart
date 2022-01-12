library flutter_mupdf;

import 'dart:async';
import 'dart:ffi';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';
import 'package:flutter_mupdf/src/mupdf_wrapper.dart';
import 'package:flutter_mupdf/src/pdf_text.dart';
import 'dart:io' show Directory;
import 'package:path/path.dart' as path;
import 'dart:convert';
import 'dart:ui';

class FlutterMuPdf {
  String libraryPath = path.join(
      Directory.current.path, 'clib', 'Debug', 'libmupdf_wrapper.dll');
  late MuPdfWrapper pdflib;

  FlutterMuPdf() {
    final dylib = DynamicLibrary.open(libraryPath);
    pdflib = MuPdfWrapper(dylib);
  }

  Pointer<MuPdfInst> newPdfInst() {
    return pdflib.newMuPdfInst();
  }

  void loadDocument(Pointer<MuPdfInst> ctx, String p) {
    var _p = p.toNativeUtf8().cast<Int8>();
    int suc = pdflib.loadDocument(ctx, _p);
    calloc.free(_p);
    if (suc > 0) {
      throw suc;
    }
  }

  int getPageCount(Pointer<MuPdfInst> ctx) {
    Pointer<Int32> p = calloc<Int32>();
    pdflib.getPageCount(ctx, p);
    int ret = p.value;
    calloc.free(p);
    return ret;
  }

  PdfText getPageText(Pointer<MuPdfInst> ctx, int pageNumber) {
    Pointer<Pointer<Utf8>> j = calloc<Pointer<Utf8>>();
    Pointer<Int32> l = calloc<Int32>();
    pdflib.getPageText(ctx, pageNumber, j, l);
    String ret = j.value.toDartString(length: l.value);
    calloc.free(j);
    calloc.free(l);
    var d = jsonDecode(ret);
    return PdfText.fromJson(d);
  }

  Future<Image> getPagePixmap(Pointer<MuPdfInst> ctx, int pageNumber) {
    Pointer<Pointer<Uint8>> raw = calloc<Pointer<Uint8>>();
    Pointer<Int32> _w = calloc<Int32>();
    Pointer<Int32> _h = calloc<Int32>();
    Pointer<Int32> _channel = calloc<Int32>();
    pdflib.getPagePixmap(ctx, pageNumber, raw, _w, _h, _channel);
    int w = _w.value;
    int h = _h.value;
    int channel = _channel.value;

    Uint8List rawPixel = raw.value.asTypedList(w * h * channel);
    var rgba = List<int>.filled(w * h * 4, 255);
    for (int i = 0; i < w * h; i++) {
      int ro = i * 3;
      int no = i * 4;
      rgba[no] = rawPixel[ro];
      rgba[no + 1] = rawPixel[ro + 1];
      rgba[no + 2] = rawPixel[ro + 2];
    }

    Uint8List rgbaList = Uint8List.fromList(rgba);

    Completer<Image> c = Completer<Image>();
    decodeImageFromPixels(rgbaList, w, h, PixelFormat.rgba8888, (Image img) {
      c.complete(img);
    });
    return c.future;
  }

  void clearMuPDF(Pointer<MuPdfInst> ctx) {
    pdflib.clearMuPDF(ctx);
  }
}
