// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LectureModel {
  final String? imagePathId;
  final String? imageUrl;
  final String? imageTitle;
  final String? uploadDate;
  final String? imageCatygory;
  LectureModel({
    required this.imagePathId,
    required this.imageUrl,
    required this.imageTitle,
    required this.uploadDate,
    required this.imageCatygory,
  });

  LectureModel copyWith({
    String? imagePathId,
    String? imageUrl,
    String? imageTitle,
    String? uploadDate,
    String? imageCatygory,
  }) {
    return LectureModel(
      imagePathId: imagePathId ?? this.imagePathId,
      imageUrl: imageUrl ?? this.imageUrl,
      imageTitle: imageTitle ?? this.imageTitle,
      uploadDate: uploadDate ?? this.uploadDate,
      imageCatygory: imageCatygory ?? this.imageCatygory,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'imagePathId': imagePathId,
      'imageUrl': imageUrl,
      'imageTitle': imageTitle,
      'uploadDate': uploadDate,
      'imageCatygory': imageCatygory,
    };
  }

  factory LectureModel.fromMap(Map<String, dynamic> map) {
    return LectureModel(
      imagePathId:
          map['imagePathId'] != null ? map['imagePathId'] as String : null,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      imageTitle:
          map['imageTitle'] != null ? map['imageTitle'] as String : null,
      uploadDate:
          map['uploadDate'] != null ? map['uploadDate'] as String : null,
      imageCatygory:
          map['imageCatygory'] != null ? map['imageCatygory'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LectureModel.fromJson(String source) =>
      LectureModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'LectureModel(imagePathId: $imagePathId, imageUrl: $imageUrl, imageTitle: $imageTitle, uploadDate: $uploadDate, imageCatygory: $imageCatygory)';
  }

  @override
  bool operator ==(covariant LectureModel other) {
    if (identical(this, other)) return true;

    return other.imagePathId == imagePathId &&
        other.imageUrl == imageUrl &&
        other.imageTitle == imageTitle &&
        other.uploadDate == uploadDate &&
        other.imageCatygory == imageCatygory;
  }

  @override
  int get hashCode {
    return imagePathId.hashCode ^
        imageUrl.hashCode ^
        imageTitle.hashCode ^
        uploadDate.hashCode ^
        imageCatygory.hashCode;
  }
}
