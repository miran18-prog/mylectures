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
import 'package:mylectures/src/zoom_image_screen.dart';
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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddImageScreen(
                        folderTitle: widget.folderTitle,
                        CameraOrGallery: false,
                      ),
                    ),
                  );
                },
                child: SvgPicture.asset(
                  'images/image-add-20-filled.svg',
                  height: 30,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddImageScreen(
                      folderTitle: widget.folderTitle,
                      CameraOrGallery: true,
                    ),
                  ),
                );
              },
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: Icon(Icons.add_a_photo),
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
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
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

                //! return all documents from folder collection
                List ids = snapshot.data!.docs
                    .map(
                      (e) => e.data(),
                    )
                    .toList();

                var Id =
                    -1; //! then we chek which index is equal to its own collection id
                for (int i = 0; i < ids.length; i++) {
                  if (ids[i]['folderName'] == widget.folderTitle) {
                    Id = i;
                  }
                }
                //! if the is was -1 it means that there is not any folders in
                if (Id == -1) {
                  return Center(
                    child: Text(
                      'There is not any images',
                      style: GoogleFonts.openSans(
                        fontSize: 25,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }

                var folderId = snapshot.data!.docs[Id]['folderId'];
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
                                      GestureDetector(
                                        onLongPress: () {
                                          showDialog(
                                            context: context,
                                            builder: ((context) => AlertDialog(
                                                  content: Container(
                                                    height: 200,
                                                    width: 300,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Text(
                                                          "Are you Sure you want to delete this image? ",
                                                          style: GoogleFonts
                                                              .openSans(
                                                            fontSize: 18,
                                                            color: Colors
                                                                .green.shade700,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    Colors.green
                                                                        .shade900,
                                                              ),
                                                              child: Text(
                                                                  "Cancel"),
                                                            ),
                                                            ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                String
                                                                    fileName =
                                                                    'lecture.jpg';

                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'folders')
                                                                    .doc(
                                                                        folderId)
                                                                    .collection(
                                                                        widget
                                                                            .folderTitle)
                                                                    .doc(lectureModel[
                                                                            index]
                                                                        .documentId)
                                                                    .delete();

                                                                final ref =
                                                                    FirebaseStorage
                                                                        .instance
                                                                        .ref()
                                                                        .child(
                                                                            'images/${lectureModel[index].imagePathId}/$fileName');
                                                                await ref
                                                                    .delete();

                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    Colors.green
                                                                        .shade900,
                                                              ),
                                                              child:
                                                                  Text("Yes"),
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )),
                                          );
                                        },
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ZoomImageScreen(
                                                          imageUrl:
                                                              lectureModel[
                                                                      index]
                                                                  .imageUrl!)));
                                        },
                                        child: Container(
                                          height: 200,
                                          width: 200,
                                          child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            imageUrl:
                                                lectureModel[index].imageUrl!,
                                            placeholder: (context, url) =>
                                                Container(
                                              alignment: Alignment.center,
                                              height: 75,
                                              width: 75,
                                              child: CircularProgressIndicator(
                                                color: Colors.green.shade900,
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          ),
                                        ),
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
                          fontSize: 20,
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
