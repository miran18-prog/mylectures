import 'dart:io' as i;

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageServices {
  final imagePicker = ImagePicker();
  Future<i.File?> getFromCamera() async {
    final image = await imagePicker.pickImage(source: ImageSource.camera);
    if (image == null) return null;
    return i.File(image.path);
  }

  Future getFromGallery() async {
    final image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    return i.File(image.path);
  }

  Future<i.File?> imageCropp({required i.File imageFile}) async {
    CroppedFile? croppedIamge =
        await ImageCropper().cropImage(sourcePath: imageFile.path);
    if (croppedIamge == null) return null;
    return i.File(croppedIamge.path);
  }
}
