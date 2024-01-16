import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource src) async {
  // creating the object
  final ImagePicker imagePicker = ImagePicker();

  XFile? file = await imagePicker.pickImage(source: src);

  if (file != null) {
    return await file.readAsBytes();
  }
  
}

