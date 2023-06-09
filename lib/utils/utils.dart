import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource souce) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: souce);

  if (file != null) {
    return await file.readAsBytes();
  }
}

void showSnackbar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        content,
        style: const TextStyle(fontSize: 16),
      ),
      // backgroundColor: Colors.red[700],
    ),
  );
}
