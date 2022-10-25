import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:mylectures/models/lecture.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseServices {
  final String? imagePathID;
  final String? folderName;
  DatabaseServices({
    this.folderName,
    this.imagePathID,
  });

  Future addImage(
    final LectureModel lec,
    final String imageCategory,
  ) async {
    return await FirebaseFirestore.instance
        .collection(imageCategory)
        .doc()
        .set(lec.toMap());
  }
}
