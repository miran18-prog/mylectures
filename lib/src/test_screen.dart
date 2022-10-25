import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mylectures/models/lecture.dart';
import 'package:mylectures/services/database_services.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  File? _image;

  Future<File?> _imageCropper({required File imageFile}) async {
    CroppedFile? croppedIamge =
        await ImageCropper().cropImage(sourcePath: imageFile.path);
    if (croppedIamge == null) return null;
    return File(croppedIamge.path);
  }

  Future _pickImage(ImageSource source, context) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      File? img = File(image.path);
      img = await _imageCropper(imageFile: img);
      setState(() {
        _image = img;
      });
    } on PlatformException catch (e) {
      print(e);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ctr = TextEditingController();
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _image != null
              ? Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(_image!),
                    ),
                  ),
                )
              : Container(
                  height: 100,
                  width: 100,
                  color: Colors.grey,
                ),
          ElevatedButton(
            onPressed: () {
              _pickImage(ImageSource.camera, context);
            },
            child: Icon(Icons.add_a_photo),
          ),
        ],
      ),
    );
  }
}
