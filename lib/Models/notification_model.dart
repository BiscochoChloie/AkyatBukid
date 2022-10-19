import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationType{
  static const follow = "follow";
  static const book = "book";
  static const request_for_rate = "request_for_rate";
}


class NotificationModel {
  String id;
  String userID;
  String message;
  Timestamp timestamp;
  bool seen;

  NotificationModel({required this.id, required this.userID, required this.timestamp, required this.seen,required this.message});

  factory NotificationModel.fromDoc(DocumentSnapshot doc) {
    return NotificationModel(
      id: doc.id,
      userID: doc['userID'],
      timestamp: doc['timestamp'],
      seen: doc['seen'],
      message: doc['message'],
    );
  }
}

