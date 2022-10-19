import 'package:akyatbukid/Models/room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";

class RoomController {
  CollectionReference rooms = FirebaseFirestore.instance.collection("room");

  Stream<DocumentSnapshot> getRoom({required String id}) {
    return rooms.doc(id).snapshots();
  }
  Future<QuerySnapshot> getRoomWithOwnerGuestID({required String owner,required String guest}) {
    return rooms.where('ownerID',isEqualTo: owner).where('guestID',isEqualTo: guest).get();
  }

  Future<QuerySnapshot> getRoomWithGuestID({required String guest}) {
    return rooms.where('guestID',isEqualTo: guest).get();
  }

  Future<QuerySnapshot> getRoomWithOwner({required String owner}) {
    return rooms.where('ownerID',isEqualTo: owner).get();
  }

  Stream<QuerySnapshot> getRooms() {
    return rooms.snapshots();
  }

  void upSert({required Room room}) {
    rooms.doc(room.id).set(room.toMap());
  }
}
