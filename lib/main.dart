import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mylectures/firebase_options.dart';
import 'package:mylectures/src/folder_content_screen.dart';
import 'package:mylectures/src/test_screen.dart';
import 'package:uuid/uuid.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HexColor('#053936'),
        body: CustomScrollView(slivers: <Widget>[
          SliverFillRemaining(
            hasScrollBody: true,
            child: Column(
              children: [
                //* upper section
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: HexColor('#053936'),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25),
                        topLeft: Radius.circular(25),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 40),
                        Text(
                          "My Courses",
                          style: GoogleFonts.openSans(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 40),
                        // Expanded(
                        //   child: GridView.count(
                        //     shrinkWrap: true,
                        //     crossAxisCount: 3,
                        //     mainAxisSpacing: 20,
                        //     crossAxisSpacing: 25,
                        //     children: [
                        //       myColumn(folderName: 'gui', context: context),
                        //       myColumn(
                        //           folderName: 'database', context: context),
                        //       myColumn(folderName: 'web', context: context),
                        //       myColumn(folderName: 'robotic', context: context),
                        //       myColumn(
                        //           folderName: 'e-bussines', context: context),
                        //       myColumn(
                        //           folderName: 'networking', context: context),
                        //     ],
                        //   ),
                        // ),
                        //* footer section
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: HexColor('#efead8'),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(25),
                                topLeft: Radius.circular(25),
                              ),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 25, left: 25),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "My Folders",
                                        style: GoogleFonts.openSans(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: HexColor('#053936')),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 15),
                                        child: Row(
                                          children: [
                                            TextButton.icon(
                                              onPressed: () {
                                                myDialog(context);
                                              },
                                              icon: Icon(
                                                Icons.folder,
                                                size: 23,
                                                color: HexColor('#053936'),
                                              ),
                                              label: Text(
                                                "Add Folder",
                                                style: GoogleFonts.openSans(
                                                  color: HexColor('#053936'),
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 40),
                                Expanded(
                                  flex: 2,
                                  child: StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('folders')
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                      if (snapshot.data == null) {
                                        return Text(
                                            "there is not any folders...");
                                      } else if (snapshot.hasError) {
                                        print(snapshot.error.toString());
                                      } else if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.green,
                                          ),
                                        );
                                      }
                                      if (snapshot.data!.docs.length == 0) {
                                        return Center(
                                          child: Text(
                                            "There is not any folders",
                                            style: GoogleFonts.openSans(
                                              color: Colors.grey,
                                              fontSize: 25,
                                            ),
                                          ),
                                        );
                                      }
                                      return GridView.builder(
                                        shrinkWrap: true,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 5,
                                          crossAxisSpacing: 5,
                                        ),
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return SizedBox(
                                            height: 100,
                                            width: double.maxFinite,
                                            child: Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            FolderContentScreen(
                                                          folderTitle: snapshot
                                                                  .data!
                                                                  .docs[index]
                                                              ['folderName'],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: SvgPicture.asset(
                                                    'images/bxs_folder-open.svg',
                                                    height: 100,
                                                    width: 100,
                                                    color: HexColor('#053936'),
                                                  ),
                                                ),
                                                Text(
                                                  snapshot.data!.docs[index]
                                                      ['folderName'],
                                                  style: GoogleFonts.openSans(
                                                    color: HexColor('#000000'),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                SizedBox(height: 2),
                                                Text(
                                                  snapshot.data.docs[index]
                                                      ['createdAt'],
                                                  style: GoogleFonts.openSans(
                                                    color: Colors.grey,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                SizedBox(height: 2),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ]));
  }

  myDialog(context) {
    TextEditingController folderNameCtr = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            height: 200,
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextField(
                  controller: folderNameCtr,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: HexColor('#053936'),
                        width: 2,
                      ),
                    ),
                    hintText: 'New folder name . . ',
                    prefixIcon: Icon(
                      Icons.drive_folder_upload_sharp,
                      color: HexColor('#053936'),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: HexColor('#005936')),
                        child: const Text("Cancel"),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () async {
                          String id = const Uuid().v4();
                          String date = DateTime.now().day.toString() +
                              '-' +
                              DateTime.now().month.toString() +
                              '-' +
                              DateTime.now().year.toString();
                          FirebaseFirestore.instance
                              .collection('folders')
                              .doc(id)
                              .set({
                            'folderName': folderNameCtr.text,
                            'createdAt': date,
                            'folderId': id,
                          });
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: HexColor('#005936'),
                        ),
                        child: const Text("Add folder"),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  myColumn({required String folderName, context}) {
    return Column(
      children: [
        SvgPicture.asset(
          'images/bxs_folder-open.svg',
          height: 75,
          width: 75,
          color: HexColor('#efead8'),
        ),
        Text(
          folderName,
          style: GoogleFonts.openSans(
            color: HexColor('#ffffff'),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
