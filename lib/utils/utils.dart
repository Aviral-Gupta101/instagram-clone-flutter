import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource souce) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: souce);

  if (_file != null) {
    return await _file.readAsBytes();
  }
  print("No file slected");
}
