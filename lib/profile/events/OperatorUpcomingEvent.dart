import 'package:akyatbukid/Models/EventModel.dart';
import 'package:akyatbukid/Models/UserModel.dart';
import 'package:akyatbukid/profile/events/listofHikers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:akyatbukid/controller/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';

class OperatorUpcomingEvent extends StatefulWidget {
  static const String id = 'event';
  final UserModel userModel;

  const OperatorUpcomingEvent({Key? key, required this.userModel})
      : super(key: key);
  @override
  _OperatorUpcomingEventState createState() => _OperatorUpcomingEventState();
}

class _OperatorUpcomingEventState extends State<OperatorUpcomingEvent> {

  static final DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: UserController().getUser(id:widget.userModel.uid),
      builder: (context, snapshot) {
        try {
          if (!snapshot.data!.exists) return Text("Loading");
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(
              child: CircularProgressIndicator(),
            );
          UserModel userModel = UserModel.fromDoc(doc: snapshot.data!);

          Stream<QuerySnapshot<Map<String, dynamic>>> eventperId =
              FirebaseFirestore.instance
                  .collection('events')
                  .where("authorId", isEqualTo: widget.userModel.uid)
                  .where("end", isGreaterThanOrEqualTo: now)
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
                    stream: eventperId,
                    builder: (context, snapshot) {
                      try {
                        if (!snapshot.hasData) return Text(" ");
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              EventModel eventModel = EventModel.fromDoc(
                                  doc: snapshot.data!.docs[index]);
                              EventModel.fromDoc(
                                  doc: snapshot.data!.docs[index]);
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ListofHikers(
                                        eventModel: eventModel,
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
                                              Text(eventModel.name,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              Text(
                                                  "${DateFormat('MMM dd, yyyy').format(eventModel.start).toString()} - ${DateFormat('MMM dd, yyyy').format(eventModel.end).toString()}",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      } catch (e) {
                        return Text("Loading");
                      }
                    }),
              ),
            ],
          );
        } catch (e) {
          return Text("Loading");
        }
      },
    );
  }
}
