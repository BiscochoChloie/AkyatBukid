import 'package:akyatbukid/Models/BookModel.dart';
import 'package:akyatbukid/Models/EventModel.dart';
import 'package:akyatbukid/Models/UserModel.dart';
import 'package:akyatbukid/controller/event_controller.dart';
import 'package:akyatbukid/profile/events/rate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';

class HikerCompletedEvent extends StatefulWidget {
  static const String id = 'event';
  final UserModel userModel;

  const HikerCompletedEvent({Key? key, required this.userModel})
      : super(key: key);
  @override
  _HikerCompletedEventState createState() => _HikerCompletedEventState();
}

class _HikerCompletedEventState extends State<HikerCompletedEvent> {

  static final DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot<Map<String, dynamic>>> bookperId = FirebaseFirestore
        .instance
        .collection('bookedEvents')
        .where("authorId", isEqualTo: widget.userModel.uid)
        .where("eventend", isLessThanOrEqualTo: now)
        .orderBy("eventend")
        .snapshots();
    return Column(
      children: [
        Text("Completed Events",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            )),
        Container(
          height: 350,
          child: StreamBuilder<QuerySnapshot>(
              stream: bookperId,
              builder: (context, snapshot) {
                try {
                  if (!snapshot.hasData) return Text("Loading");
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        BookModel bookModel =
                            BookModel.fromDoc(doc: snapshot.data!.docs[index]);
                        BookModel.fromDoc(doc: snapshot.data!.docs[index]);

                        return 
                        GestureDetector(
                            onTap: () {
                              EventController().getEvent(id:bookModel.eventId ).first.then((value) {
                                EventModel event = EventModel.fromDoc(doc: value);
                                // event.ratingInformation.forEach((element) {
                                //
                                //   print(element);
                                // });
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => Rate(
                                      eventModel: event,
                                    ),
                                  ),
                                );
                              });

                            },
                            child:Card(
                                color: Colors.red[200],
                                elevation: 5.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.event,
                                        size: 50,
                                        color: Colors.black,
                                      ),
                                      Container(
                                        padding: EdgeInsets.fromLTRB(
                                            15.0, 12.0, 10.0, 5.0),
                                        child: Column(
                                          children: [
                                            Text(bookModel.bukidname,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                            Text(
                                                "${DateFormat('MMM dd, yyyy').format(bookModel.eventstart).toString()} - ${DateFormat('MMM dd, yyyy').format(bookModel.eventend).toString()}",
                                                // eventModel.end,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  // )
                                ))
                        );

                      });
                } catch (e) {
                  return Text("Loading");
                }
              }),
        ),
      ],
    );
  }
}
