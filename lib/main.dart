import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mylectures/database/database_services.dart';
import 'package:mylectures/models/model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var databasePath = await getDatabasesPath();
  var path = join(databasePath, "DEMO.db");

  await databaseFactory.deleteDatabase(path);
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
      backgroundColor: HexColor('#34295B'),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverFillRemaining(
            hasScrollBody: true,
            child: Column(
              children: [
                //* upper section
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 75),
                        Text(
                          "My Storage",
                          style: GoogleFonts.openSans(
                            color: HexColor('#FFFFFF'),
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          height: 3,
                          width: 300,
                          decoration: BoxDecoration(
                            color: HexColor('#FF8A00'),
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        SizedBox(height: 10),
                        RichText(
                          text: const TextSpan(
                            text: '50Gb ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            children: const <TextSpan>[
                              TextSpan(
                                text: 'of 100Gb used',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                //* footer section
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25),
                        topLeft: Radius.circular(25),
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 25, left: 25),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "My Folders",
                                style: GoogleFonts.openSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: Row(
                                  children: [
                                    TextButton.icon(
                                      onPressed: () {
                                        myDialog(context);
                                      },
                                      icon: Icon(
                                        Icons.folder,
                                        size: 23,
                                        color: HexColor('#FF8A00'),
                                      ),
                                      label: Text(
                                        "Add Folder",
                                        style: GoogleFonts.openSans(
                                          color: HexColor('#FF8A00'),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
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
                                  itemBuilder:
                                      (BuildContext context, int index) {
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
                                            ),
                                          ),
                                          Text(
                                            files[index],
                                            style: GoogleFonts.openSans(
                                              color: HexColor('#000000'),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            DateTime.now().day.toString() +
                                                '-' +
                                                DateTime.now()
                                                    .month
                                                    .toString() +
                                                '-' +
                                                DateTime.now().year.toString(),
                                            style: GoogleFonts.openSans(
                                              color: Colors.grey,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            '5Mb',
                                            style: GoogleFonts.openSans(
                                              color: Colors.grey,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                )
                              : Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'images/fluent_calendar-empty-16-filled.svg',
                                        color: HexColor('#FF8A00'),
                                        height: 100,
                                        width: 100,
                                      ),
                                      SizedBox(height: 25),
                                      Text(
                                        'There is not any folders . . .',
                                        style: GoogleFonts.openSans(
                                          color: HexColor('#FF8A00'),
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
          )
        ],
      ),
    );
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
                        color: HexColor('#FF8A00'),
                        width: 2,
                      ),
                    ),
                    hintText: 'New folder name . . ',
                    prefixIcon: Icon(
                      Icons.drive_folder_upload_sharp,
                      color: HexColor('#FF8A00'),
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
                            backgroundColor: HexColor('#FF8A00')),
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
                          backgroundColor: HexColor('#FF8A00'),
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
}
