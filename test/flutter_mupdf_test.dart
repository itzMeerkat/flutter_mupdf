import 'dart:ffi';

import 'package:flutter_mupdf/clibmypdf.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mupdf/flutter_mupdf.dart';

void main() {
  var p = FlutterPdfPlugin();
  late Pointer<MuPdfInst> ctx;
  setUpAll(() {
    ctx = p.newPdfInst();
    p.loadDocument(ctx, "./chapter3.pdf");
  });

  test("getPageCount", () {
    var pc = p.getPageCount(ctx);
    print(pc);
  });

  test("getPageText", () {
    var json = p.getPageText(ctx, 0);
    print(json.blocks.length);
  });

  test("getPagePixmap", () async {
    var res = await p.getPagePixmap(ctx, 0);
    print(res.height);
    print(res.width);
  });
  tearDownAll(() {
    p.clearMuPDF(ctx);
  });
}
