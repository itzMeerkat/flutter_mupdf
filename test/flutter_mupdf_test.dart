import 'dart:ffi';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter_mupdf/src/mupdf_wrapper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mupdf/src/flutter_mupdf.dart';

void main() {
  var p = FlutterMuPdf();
  late Pointer<MuPdfInst> ctx;
  setUpAll(() {
    ctx = p.newPdfInst();
    p.loadDocument(ctx, "./mxnet-learningsys.pdf");
  });

  test("getPageCount", () {
    var pc = p.getPageCount(ctx);
    print(pc);
  });

  test("getPageText", () {
    var json = p.getPageText(ctx, 0);
    var res = jsonEncode(json);
    print(res);
  });

  test("getPagePixmap", () async {
    var res = await p.getPagePixmap(ctx, 0);
    print(res.height);
    print(res.width);

    var png = res.toByteData(format: ImageByteFormat.png);
    png.then((value) {
      var f = File("./myrastpage.png");
      f.create();
      f.writeAsBytesSync(
          value!.buffer.asInt8List(value.offsetInBytes, value.lengthInBytes));
    });
  });

  tearDownAll(() {
    p.clearMuPDF(ctx);
  });
}
