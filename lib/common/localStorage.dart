import 'dart:io';
import 'dart:developer' as dev;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class LocalStorage {
  Future<String> getInternalDirectory() async {
    final Directory result = await getApplicationSupportDirectory();
    dev.log('Este é o diretório interno: ${result.path}');
    return result.path;
  }

  Future<String> saveFileFromAssets(
      String assetFileName, String filename) async {
    ByteData byteData = await rootBundle.load('assets/$assetFileName');

    String mainPath = await getInternalDirectory();
    // this creates the file image
    File file = await File('$mainPath/$filename').create(recursive: true);

    // copies data byte by byte
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file.path;
  }
}
