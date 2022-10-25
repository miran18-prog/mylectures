import 'dart:io' as i;
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mylectures/models/lecture.dart';
import 'package:mylectures/src/add_image_screen.dart';
import 'package:uuid/uuid.dart';

class FolderContentScreen extends StatefulWidget {
  FolderContentScreen({super.key, required this.folderTitle});
  final String folderTitle;
  @override
  State<FolderContentScreen> createState() => _FolderContentScreenState();
}

class _FolderContentScreenState extends State<FolderContentScreen> {
  @override
  Widget build(BuildContext context) {
    File? _image;

    _pickImage(ImageSource s, context) async {
      try {} on PlatformException catch (e) {
        print(e);
        Navigator.of(context).pop();
      }
    }

    TextEditingController imageTitleCtrl = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black,
          size: 30,
        ),
        title: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                widget.folderTitle,
                style: GoogleFonts.openSans(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () async {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AddImageScreen(
                            folderTitle: widget.folderTitle,
                          )));
                },
                child: SvgPicture.asset(
                  'images/image-add-20-filled.svg',
                  height: 30,
                ),
              ),
            )
          ],
        ),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: HexColor('#efead8'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('folders').snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Text(
                    "There is not any folders",
                    style: TextStyle(color: Colors.green.shade900),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Container();
                }
                var folderId = snapshot.data!.docs[0]['folderId'];
                print(folderId);
                return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('folders')
                        .doc(folderId)
                        .collection(widget.folderTitle)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.green,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        print(snapshot.error.toString());
                      } else if (snapshot.hasData) {
                        List<LectureModel> lectureModel = snapshot.data!.docs
                            .map(
                              (e) => LectureModel.fromMap(
                                e.data(),
                              ),
                            )
                            .toList();
                        if (lectureModel.isEmpty) {
                          return Text(
                            "There is not any images",
                            style: GoogleFonts.openSans(
                              color: Colors.grey,
                              fontSize: 25,
                            ),
                          );
                        }
                        return Expanded(
                          child: GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisExtent: 300,
                            ),
                            itemCount: lectureModel.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: lectureModel[index].imageUrl!,
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(
                                          color: Colors.green.shade900,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                      SizedBox(height: 10),
                                      Expanded(
                                        child: AutoSizeText(
                                          lectureModel[index].imageTitle!,
                                          style: GoogleFonts.openSans(),
                                          presetFontSizes: [
                                            21,
                                            20,
                                            19,
                                            18,
                                            17,
                                            16,
                                            15,
                                            14
                                          ],
                                        ),
                                      ),
                                    ],
                                  ));
                            },
                          ),
                        );
                      }
                      return Text(
                        'there is not any images',
                        style: GoogleFonts.openSans(
                          fontSize: 40,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      );
                    });
              },
            ),
          ],
        ),
      ),
    );
  }
}
