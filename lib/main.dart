import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mylectures/database/database_services.dart';
import 'package:mylectures/models/model.dart';
import 'package:mylectures/test_screen.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
  List files = [];
  TextEditingController folderNameCtr = TextEditingController();

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
                        Expanded(
                          child: GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 3,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 25,
                            children: [
                              myColumn(folderName: 'GUI'),
                              myColumn(folderName: 'Database'),
                              myColumn(folderName: 'Web'),
                              myColumn(folderName: 'Robotic'),
                              myColumn(folderName: 'E-bussines'),
                              myColumn(folderName: 'Networking'),
                            ],
                          ),
                        ),
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
                                  child: files.isEmpty == false
                                      ? GridView.builder(
                                          shrinkWrap: true,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            mainAxisSpacing: 5,
                                            crossAxisSpacing: 5,
                                          ),
                                          itemCount: files.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return SizedBox(
                                              height: 100,
                                              width: double.maxFinite,
                                              child: Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      print('hiii');
                                                    },
                                                    child: SvgPicture.asset(
                                                      'images/bxs_folder-open.svg',
                                                      height: 100,
                                                      width: 100,
                                                      color:
                                                          HexColor('#053936'),
                                                    ),
                                                  ),
                                                  Text(
                                                    files[index],
                                                    style: GoogleFonts.openSans(
                                                      color:
                                                          HexColor('#000000'),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  SizedBox(height: 2),
                                                  Text(
                                                    DateTime.now()
                                                            .day
                                                            .toString() +
                                                        '-' +
                                                        DateTime.now()
                                                            .month
                                                            .toString() +
                                                        '-' +
                                                        DateTime.now()
                                                            .year
                                                            .toString(),
                                                    style: GoogleFonts.openSans(
                                                      color: Colors.grey,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  SizedBox(height: 2),
                                                  Text(
                                                    '5Mb',
                                                    style: GoogleFonts.openSans(
                                                      color: Colors.grey,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        )
                                      : Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                'images/fluent_calendar-empty-16-filled.svg',
                                                color: HexColor('#005936'),
                                                height: 100,
                                                width: 100,
                                              ),
                                              SizedBox(height: 25),
                                              Text(
                                                'There is not any folders . . .',
                                                style: GoogleFonts.openSans(
                                                  color: HexColor('#005936'),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
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
                  ),
                ),
              ],
            ),
          )
        ]));
  }

  myDialog(context) {
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
                        onPressed: () {
                          files.add(folderNameCtr.text);

                          setState(() {});
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

  myColumn({required String folderName}) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {},
          child: SvgPicture.asset(
            'images/bxs_folder-open.svg',
            height: 75,
            width: 75,
            color: HexColor('#efead8'),
          ),
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
