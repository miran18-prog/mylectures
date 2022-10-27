import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mylectures/models/lecture.dart';
import 'package:uuid/uuid.dart';

class AddImageScreen extends StatefulWidget {
  const AddImageScreen(
      {super.key, required this.folderTitle, required this.CameraOrGallery});

  final folderTitle;
  //! camera = 1 , gallery = 0
  final CameraOrGallery;
  @override
  State<AddImageScreen> createState() => _AddImageScreenState();
}

class _AddImageScreenState extends State<AddImageScreen> {
  @override
  File? _image;
  final imageTitleCtrl = TextEditingController();
  bool isLoadind = false;
  double h = 50;
  double w = 100;
  Color bgColor = Colors.green.shade900;
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.now();
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black, size: 30),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 75,
            ),
            GestureDetector(
              onTap: () async {
                if (widget.CameraOrGallery) {
                  final image = await ImagePicker().pickImage(
                    source: ImageSource.camera,
                  );
                  if (image == null) return;
                  File? img = File(image.path);
                  setState(() {
                    this._image = img;
                  });
                } else {
                  final image = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (image == null) return;
                  File? img = File(image.path);
                  setState(() {
                    this._image = img;
                  });
                }
              },
              child: _image == null
                  ? Container(
                      height: 250,
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                      ),
                      child: const Icon(
                        Icons.add,
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
            const SizedBox(
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
                  label: const Text("Image Title"),
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
            const SizedBox(
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
                        setState(() {
                          isLoadind = true;
                          bgColor = Colors.transparent;
                        });
                        String imagePathId = const Uuid().v1();
                        String documentId = const Uuid().v4();
                        String fileName = 'lecture.jpg';
                        try {
                          if (_image == null) return;

                          final ref = FirebaseStorage.instance
                              .ref()
                              .child('images/$imagePathId/$fileName');

                          await ref.putFile(_image!);

                          String downloadUri = await ref.getDownloadURL();
                          LectureModel lectureModel = LectureModel(
                              imagePathId: imagePathId,
                              imageUrl: downloadUri,
                              imageTitle: imageTitleCtrl.text,
                              uploadDate: date.toString(),
                              imageCatygory: widget.folderTitle,
                              documentId: documentId);
                          print(lectureModel);
                          FirebaseFirestore.instance
                              .collection('folders')
                              .doc(snapshot.data!.docs[0]['folderId'])
                              .collection(widget.folderTitle)
                              .doc(documentId)
                              .set(lectureModel.toMap());
                          Navigator.of(context).pop();
                          setState(() {
                            isLoadind = false;
                            bgColor = Colors.green.shade900;
                          });
                        } on FirebaseException catch (e) {
                          print(e);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: bgColor, elevation: 0),
                      child: !isLoadind
                          ? const Text(
                              ("Add Image"),
                            )
                          : SizedBox(
                              width: 35,
                              child: CircularProgressIndicator(
                                color: Colors.green,
                              ),
                            ),
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
