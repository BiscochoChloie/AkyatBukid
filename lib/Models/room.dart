import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  String id,ownerID,guestID;

  Room({
    required this.id,
    required this.ownerID,
    required this.guestID
  });

  factory Room.fromDoc(DocumentSnapshot doc) {
    return Room(
      id: doc.id,
      guestID: doc['guestID'],
      ownerID: doc['ownerID'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ownerID': ownerID,
      'guestID': guestID,
    };
  }

}
