import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ImageSources {
  final _picker = ImagePicker();

  Future<Uint8List?> fromCamera() async {
    final shot = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1024,
    );
    return shot == null ? null : await shot.readAsBytes();
  }

  Future<Uint8List?> fromGallery() async {
    final shot = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
    );
    return shot == null ? null : await shot.readAsBytes();
  }

  Future<Uint8List?> fromUrl(String url) async {
    final response = await http
        .get(Uri.parse(url))
        .timeout(const Duration(seconds: 10));
    if (response.statusCode == 200 &&
        response.headers['content-type']?.startsWith('image/') == true) {
      return response.bodyBytes;
    } else if (response.statusCode != 200) {
      throw Exception('Failed to download image: ${response.statusCode}');
    } else {
      throw Exception(
        'Invalid content type: ${response.headers['content-type']}',
      );
    }
  }
}
