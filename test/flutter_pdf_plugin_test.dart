import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_pdf_plugin/flutter_pdf_plugin.dart';
import 'dart:ui';

void main() {
  // const MethodChannel channel = MethodChannel('flutter_pdf_plugin');

  // TestWidgetsFlutterBinding.ensureInitialized();
  var p = FlutterPdfPlugin();
  setUp(() {
    p.loadDocument("./mxnet-learningsys.pdf");
  });

  test("getPageCount", () {
    var pc = p.getPageCount();
    print(pc);
  });

  test("getPageText", () {
    var json = p.getPageText(0);
    print(json.blocks.length);
  });

  test("getPagePixmap", () {
    var res = p.getPagePixmap(0);
    print(res!.height);
    print(res.width);
  });

  p.clearMuPDF();
}
