import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";

class BukidController {
  CollectionReference bukid = FirebaseFirestore.instance.collection("bukid");

  Stream<DocumentSnapshot> getBukid({required String id}) {
    return bukid.doc(id).snapshots();
  }

  Stream<QuerySnapshot> getBukids() {
    return bukid.snapshots();
  }
}
