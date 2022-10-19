import 'package:akyatbukid/Models/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";


class ChatController{
  CollectionReference chat = FirebaseFirestore.instance.collection("chat");

  Stream<DocumentSnapshot> getChat({required String id}) {
    return chat.doc(id).snapshots();
  }
  Stream<QuerySnapshot> getChatWithRoomID({required String roomID}) {
    return chat.where('roomID',isEqualTo: roomID).snapshots();
  }

  void upSert({required Chat room}) {
    chat.doc(room.id).set(room.toMap());
  }
  
}