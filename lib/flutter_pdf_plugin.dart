import 'dart:async';
import 'dart:ffi';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';
import 'dart:io' show Directory, Platform;
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart';

typedef HelloWorld = void Function(Pointer<Pointer<Utf8>>);
typedef hello_world_func = Void Function(Pointer<Pointer<Utf8>>);

class FlutterPdfPlugin {
  String libraryPath =
      path.join(Directory.current.path, 'clib', 'Debug', 'flutter_mupdf.dll');

  FlutterPdfPlugin() {
    final dylib = DynamicLibrary.open(libraryPath);
    final HelloWorld hello = dylib
        .lookup<NativeFunction<hello_world_func>>('hello_world')
        .asFunction();
    Pointer<Pointer<Utf8>> i = calloc<Pointer<Utf8>>();
    print("!");
    hello(i);
    print(i);
    // print(i)
    // print(i.value.toDartString(length: 9));
    print(i.value.toDartString());
    calloc.free(i);
    print("!");
  }
}
