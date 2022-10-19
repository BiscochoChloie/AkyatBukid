import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";

class BookController {
  CollectionReference event = FirebaseFirestore.instance.collection("events");

  Stream<DocumentSnapshot> getEvent({required String id}) {
    return event.doc(id).snapshots();
  }

  Stream<QuerySnapshot> getEvents() {
    return event.snapshots();
  }
}