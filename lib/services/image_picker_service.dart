import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService{

  Future<PickedFile> pickImage({@required ImageSource source}) async {
    return ImagePicker().getImage(source: source);
  }

}