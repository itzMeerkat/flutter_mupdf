library flutter_mupdf;

import 'dart:async';
import 'dart:ffi';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';
import 'package:flutter_mupdf/clibmypdf.dart';
import 'package:flutter_mupdf/pdf_text.dart';
import 'dart:io' show Directory;
import 'package:path/path.dart' as path;
import 'dart:convert';
import 'dart:ui';

class FlutterPdfPlugin {
  String libraryPath =
      path.join(Directory.current.path, 'clib', 'Debug', 'flutter_mupdf.dll');
  late libMuPdf pdflib;

  FlutterPdfPlugin() {
    final dylib = DynamicLibrary.open(libraryPath);
    pdflib = libMuPdf(dylib);

    // var newf = dylib.lookupFunction<Pointer<MuPdfInst> Function(),
    //     Pointer<MuPdfInst> Function()>("NewMuPdfInst");
    // print(newf);
  }

  Pointer<MuPdfInst> newPdfInst() {
    print("new inst");
    return pdflib.NewMuPdfInst();
  }

  void loadDocument(Pointer<MuPdfInst> ctx, String p) {
    print("load doc " + p);
    var _p = p.toNativeUtf8().cast<Int8>();
    int suc = pdflib.LoadDocument(ctx, _p);
    calloc.free(_p);
    if (suc > 0) {
      throw suc;
    }
  }

  int getPageCount(Pointer<MuPdfInst> ctx) {
    print("get page cnt");
    Pointer<Int32> p = calloc<Int32>();
    var suc = pdflib.GetPageCount(ctx, p);
    int ret = p.value;
    calloc.free(p);
    return ret;
  }

  PdfText getPageText(Pointer<MuPdfInst> ctx, int pageNumber) {
    print("get text");
    Pointer<Pointer<Utf8>> j = calloc<Pointer<Utf8>>();
    Pointer<Int32> l = calloc<Int32>();
    pdflib.GetPageText(ctx, pageNumber, j, l);
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
    pdflib.GetPagePixmap(ctx, pageNumber, raw, _w, _h, _channel);
    int w = _w.value;
    int h = _h.value;
    int channel = _channel.value;

    Uint8List rawPixel = raw.value.asTypedList(w * h * channel);
    List<int> rgba = [];
    for (int i = 0; i < rawPixel.length; i++) {
      rgba.add(rawPixel[i]);
      if ((i + 1) % 3 == 0) {
        rgba.add(0);
      }
    }

    Uint8List rgbaList = Uint8List.fromList(rgba);

    Completer<Image> c = Completer<Image>();
    decodeImageFromPixels(rgbaList, w, h, PixelFormat.rgba8888, (Image img) {
      c.complete(img);
    });
    // return ret;
    return c.future;
  }

  void clearMuPDF(Pointer<MuPdfInst> ctx) {
    print("clear");
    pdflib.ClearMuPDF(ctx);
  }
}
