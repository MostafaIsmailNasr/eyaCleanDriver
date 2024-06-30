import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

class CompressionUtil {
  static Future<File> compressImage(String path) async {
    Uint8List? imageBytes = await FlutterImageCompress.compressWithFile(
      path,
      minWidth: 800,
      minHeight: 600,
      quality: 50,
    );
    File compressedImage = File(path)..writeAsBytesSync(imageBytes!);
    return compressedImage;
  }

}