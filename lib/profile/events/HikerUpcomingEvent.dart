import 'package:akyatbukid/Models/BookModel.dart';
import 'package:akyatbukid/Models/EventModel.dart';
import 'package:akyatbukid/Models/UserModel.dart';
import 'package:akyatbukid/bookingdetails/receipt.dart';
import 'package:akyatbukid/profile/events/hikerReceipt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:akyatbukid/controller/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';

class HikerUpcomingEvent extends StatefulWidget {
  static const String id = 'book';
  final UserModel userModel;

  const HikerUpcomingEvent({Key? key, required this.userModel})
      : super(key: key);
  @override
  _HikerUpcomingEventState createState() => _HikerUpcomingEventState();
}

class _HikerUpcomingEventState extends State<HikerUpcomingEvent> {


  static final DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    print(widget.userModel.uid);
    Stream<QuerySnapshot<Map<String, dynamic>>> bookperId = FirebaseFirestore
        .instance
        .collection('bookedEvents')
        .where("authorId", isEqualTo: widget.userModel.uid)
        .where("eventend", isGreaterThanOrEqualTo: now)
        .snapshots();
    return Column(
      children: [
        Text(
          "Upcoming Events",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          height: 350,
          child: StreamBuilder<QuerySnapshot>(
              stream: bookperId,
              builder: (context, snapshot) {
                try {
                  if (!snapshot.hasData) return Text(" ");
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
                        return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => HikerReceipt(
                                    bookModel: bookModel,
                                  ),
                                ),
                              );
                            },
                            child: Card(
                                color: Colors.green[200],
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
                                                style: TextStyle(
                                                  fontSize: 12,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )));
                        // );
                      });
                } catch (e) {
                  return Text(e.toString());
                }
              }),
        ),
      ],
    );
  }
}
