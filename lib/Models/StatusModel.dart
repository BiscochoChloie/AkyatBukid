import 'package:cloud_firestore/cloud_firestore.dart';

class StatusModel {
  String id;
  String authorId;
  String text;
  String image;
  String bukid;
  Timestamp timestamp;
  int likes;
  int comments;

  StatusModel(
      {required this.id,
      required this.authorId,
      required this.text,
      required this.image,
       required this.bukid,
      required this.timestamp,
      required this.likes,
      required this.comments});

  factory StatusModel.fromDoc(DocumentSnapshot doc) {
    return StatusModel(
      id: doc.id,
      authorId: doc['authorId'],
      text: doc['text'],
      image: doc['image'],
      bukid: doc['bukid'],
      timestamp: doc['timestamp'],
      likes: doc['likes'],
      comments: doc['comments'],
    );
  }
}
