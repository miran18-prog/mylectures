import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mylectures/models/lecture.dart';
import 'package:uuid/uuid.dart';

class AddImageScreen extends StatefulWidget {
  const AddImageScreen({super.key, required this.folderTitle});

  final folderTitle;

  @override
  State<AddImageScreen> createState() => _AddImageScreenState();
}

class _AddImageScreenState extends State<AddImageScreen> {
  @override
  File? _image;
  final imageTitleCtrl = TextEditingController();

  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.now();
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black, size: 30),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 75,
            ),
            GestureDetector(
              onTap: () async {
                final image =
                    await ImagePicker().pickImage(source: ImageSource.camera);
                if (image == null) return;
                File? img = File(image.path);
                setState(() {
                  this._image = img;
                });
                print(_image);
              },
              child: _image == null
                  ? Container(
                      height: 250,
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                      ),
                      child: Icon(
                        Icons.add_a_photo,
                        size: 40,
                        color: Colors.white,
                      ),
                    )
                  : Container(
                      height: 250,
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(_image!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: imageTitleCtrl,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.green.shade900),
                  ),
                  label: Text("Image Title"),
                  labelStyle: GoogleFonts.openSans(
                    color: Colors.green.shade900,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.green.shade900),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            SizedBox(
              child: SizedBox(
                height: 60,
                width: 250,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('folders')
                      .where('folderName', isEqualTo: widget.folderTitle)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.data == null)
                      return Text(
                        "there is not any images",
                        style: TextStyle(color: Colors.green.shade900),
                      );
                    return ElevatedButton(
                      onPressed: () async {
                        print('dddddd');
                        String id = Uuid().v1();
                        String fileName = 'lecture.jpg';
                        try {
                          if (_image == null) return;
                          final ref = FirebaseStorage.instance
                              .ref()
                              .child('images/$id/$fileName');

                          await ref.putFile(_image!);

                          String downloadUri = await ref.getDownloadURL();
                          LectureModel lectureModel = LectureModel(
                              imagePathId: id,
                              imageUrl: downloadUri,
                              imageTitle: imageTitleCtrl.text,
                              uploadDate: date.toString(),
                              imageCatygory: widget.folderTitle);
                          print(lectureModel);
                          FirebaseFirestore.instance
                              .collection('folders')
                              .doc(snapshot.data!.docs[0]['folderId'])
                              .collection(widget.folderTitle)
                              .add(lectureModel.toMap());
                          Navigator.of(context).pop();
                        } on FirebaseException catch (e) {
                          print(e);
                        }
                      },
                      child: Text(
                        ("Add Image"),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade900),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
