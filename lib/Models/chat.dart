import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  String id, roomID;
  String fromUserID, toUserID, message;
  Timestamp timestamp;
  bool seen;

  Chat(
      {required this.id,
        required this.roomID,
        required this.fromUserID,
        required this.toUserID,
        required this.timestamp,
        required this.message,
        this.seen = false,
      });

  factory Chat.fromDoc(DocumentSnapshot doc) {
    return Chat(
      id: doc.id,
      toUserID: doc['toUserID'],
      roomID: doc['roomID'],
      fromUserID: doc['fromUserID'],
      timestamp: doc['timestamp'],
      message: doc['message'],
      seen: doc['seen'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'toUserID': toUserID,
      'roomID': roomID,
      'fromUserID': fromUserID,
      'timestamp': timestamp,
      'message': message,
      'seen': seen,
    };
  }
}
