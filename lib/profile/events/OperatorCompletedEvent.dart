import 'package:akyatbukid/Models/EventModel.dart';
import 'package:akyatbukid/Models/UserModel.dart';
import 'package:akyatbukid/Models/rating_information.dart';
import 'package:akyatbukid/services/separator.dart';
import 'package:akyatbukid/profile/events/listofHikers.dart';
import 'package:akyatbukid/profile/events/review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:akyatbukid/controller/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';

class OperatorCompletedEvent extends StatefulWidget {
  static const String id = 'event';
  final UserModel userModel;

  const OperatorCompletedEvent({Key? key, required this.userModel})
      : super(key: key);
  @override
  _OperatorCompletedEventState createState() => _OperatorCompletedEventState();
}

class _OperatorCompletedEventState extends State<OperatorCompletedEvent> {
  static final DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: UserController().getUser(id: widget.userModel.uid),
      builder: (context, snapshot) {
        try {
          if (!snapshot.data!.exists) return const Text("Loading");
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          UserModel userModel = UserModel.fromDoc(doc: snapshot.data!);
          Stream<QuerySnapshot<Map<String, dynamic>>> eventperId =
              FirebaseFirestore.instance
                  .collection('events')
                  .where("authorId", isEqualTo: widget.userModel.uid)
                  .where("end", isLessThanOrEqualTo: now)
                  .orderBy("end")
                  .snapshots();
          return Column(
            children: [
              const Text("Completed Events",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(
                height: 350,
                child: StreamBuilder<QuerySnapshot>(
                    stream: eventperId,
                    builder: (context, snapshot) {
                      try {
                        if (!snapshot.hasData) return const Text(" ");
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
                              List<RatingInformation> ratingInforcations = [];
                              for (var element
                                  in eventModel.ratingInformation) {
                                List<String> data = element.toString().split(
                                    Separator.ratingInformationSeparator);
                                RatingInformation ratingInformation =
                                    RatingInformation(
                                        double.parse(data[0]),
                                        data[1],
                                        data[2],
                                        data[3],
                                        int.parse(data[4]));
                                ratingInforcations.add(ratingInformation);
                              }

                              return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => Review(
                                          ratingInformation: ratingInforcations,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Card(
                                      color: Colors.red[200],
                                      elevation: 5.0,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Icon(
                                              Icons.event,
                                              size: 50,
                                              color: Colors.black,
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      15.0, 12.0, 10.0, 5.0),
                                              child: Column(
                                                children: [
                                                  Text(eventModel.name,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )),
                                                  Text(
                                                      "${DateFormat('MMM dd, yyyy').format(eventModel.start).toString()} - ${DateFormat('MMM dd, yyyy').format(eventModel.end).toString()}",
                                                      // eventModel.end,
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )));
                            });
                      } catch (e) {
                        return const Text("Loading");
                      }
                    }),
              ),
            ],
          );
        } catch (e) {
          return const Text("Loading");
        }
      },
    );
  }
}
