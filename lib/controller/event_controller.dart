import 'package:akyatbukid/Models/EventModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class EventController {
  CollectionReference event = FirebaseFirestore.instance.collection("events");

    Stream<DocumentSnapshot> getEvent({required String id}) {
    return event.doc(id).snapshots();
  }

  Stream<QuerySnapshot> getEvents() {
    return event.orderBy('end', descending: true).snapshots();
  }

  void upSert({required EventModel event}) {
    this.event.doc(event.id).set(event.toMap());
  }
}

