import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";

class UserController {
  CollectionReference users = FirebaseFirestore.instance.collection("users");

  Stream<DocumentSnapshot> getUser({required String id}) {
    return users.doc(id).snapshots();
  }

  Future<DocumentSnapshot> getUserD({required String id}) {
    return users.doc(id).get();
  }

  Stream<QuerySnapshot> getUsers() {
    return users.snapshots();
  }
}
