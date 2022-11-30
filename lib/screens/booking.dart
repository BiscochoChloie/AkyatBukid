import 'dart:core';
import 'package:akyatbukid/Models/EventModel.dart';
import 'package:akyatbukid/Models/UserModel.dart';
import 'package:akyatbukid/Models/BukidModel.dart';
import 'package:akyatbukid/bookingdetails/mtdetails.dart';
import 'package:akyatbukid/controller/bukid_controller.dart';
import 'package:akyatbukid/controller/event_controller.dart';
import 'package:akyatbukid/createdetails/createdetail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:akyatbukid/controller/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";

class BookingPage extends StatefulWidget {
  static const String id = 'booking';
  final UserModel userModel;

  const BookingPage({Key? key, required this.userModel}) : super(key: key);
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  User? user = FirebaseAuth.instance.currentUser;

  static final DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: UserController().getUser(id: user!.uid),
      builder: (context, snapshot) {
        try {
          if (!snapshot.data!.exists) return const Text("Loading");
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          //
          UserModel userModel = UserModel.fromDoc(doc: snapshot.data!);
          return SizedBox(
            height: 530,
            child: userModel.usertype == 'H I K E R'
                ? StreamBuilder<QuerySnapshot>(
                    stream: EventController().getEvents(),
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
                              // children: snapshot.data!.docs.map((data) {
                              //   BukidModel bukidModel = BukidModel.fromDoc(doc: data);

                              return Card(
                                elevation: 3.0,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 5,
                                            bottom: 0),
                                        child: FittedBox(
                                          child: Material(
                                            color: Colors.white,
                                            child: now.isAfter(eventModel.end)
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Column(
                                                        children: [
                                                          Center(
                                                            child: Stack(
                                                              children: <
                                                                  Widget>[
                                                                SizedBox(
                                                                  width: 150.0,
                                                                  child:
                                                                      ClipRRect(
                                                                    child: Image.network(
                                                                        eventModel
                                                                            .imageURL,
                                                                        fit: BoxFit
                                                                            .contain,
                                                                        color: Colors.grey[
                                                                            500],
                                                                        colorBlendMode:
                                                                            BlendMode.modulate),
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  top: 20,
                                                                  right: 0,
                                                                  child:
                                                                      Container(
                                                                    width:
                                                                        150.0,
                                                                    color: Colors
                                                                        .black54,
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            10),
                                                                    child:
                                                                        const Text(
                                                                      'Event Ended',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              10,
                                                                          color: Colors
                                                                              .white,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      3.0,
                                                                  vertical:
                                                                      3.0),
                                                          // ignore: deprecated_member_use
                                                          child: MaterialButton(
                                                            height: 25.0,
                                                            color: Colors
                                                                .green[800],
                                                            onPressed: null,
                                                            disabledColor:
                                                                Colors.black12,
                                                            disabledTextColor:
                                                                Colors.blueGrey,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0)),
                                                            child: const Text(
                                                                'Join Event',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        13)),
                                                          ))
                                                    ],
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Column(
                                                        children: [
                                                          SizedBox(
                                                            width: 150.0,
                                                            child: ClipRRect(
                                                              child:
                                                                  Image.network(
                                                                eventModel
                                                                    .imageURL,
                                                                fit: BoxFit
                                                                    .contain,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      3.0,
                                                                  vertical:
                                                                      3.0),
                                                          // ignore: deprecated_member_use
                                                          child: MaterialButton(
                                                            height: 25.0,
                                                            color: Colors
                                                                .green[800],
                                                            onPressed: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        MtDetails(
                                                                            eventModel,
                                                                            userModel)),
                                                              );
                                                            },
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0)),
                                                            child: const Text(
                                                                'Join Event',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        13)),
                                                          ))
                                                    ],
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 10,
                                          bottom: 10),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 20,
                                            backgroundImage: eventModel
                                                    .profilePicture.isEmpty
                                                ? const AssetImage(
                                                    'assets/images/placeholder.png')
                                                : NetworkImage(eventModel
                                                        .profilePicture)
                                                    as ImageProvider,
                                          ),
                                          const SizedBox(width: 10),
                                          Column(
                                            children: [
                                              Text(eventModel.authorname,
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              const Text('TOUR OPERATOR',
                                                  style:
                                                      TextStyle(fontSize: 11)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                      } catch (e) {
                        return const Text("Loading");
                      }
                    })
                : StreamBuilder<QuerySnapshot>(
                    stream: BukidController().getBukids(),
                    builder: (context, snapshot) {
                      try {
                        if (!snapshot.hasData) return const Text("Loading");

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              BukidModel bukidModel = BukidModel.fromDoc(
                                  doc: snapshot.data!.docs[index]);
                              BukidModel.fromDoc(
                                  doc: snapshot.data!.docs[index]);
                              // children: snapshot.data!.docs.map((data) {
                              //   BukidModel bukidModel = BukidModel.fromDoc(doc: data);
                              return Card(
                                elevation: 3.0,
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: FittedBox(
                                      child: Material(
                                        color: Colors.white,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Column(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 10, 8, 8),
                                                  width: 150.0,
                                                  child: ClipRRect(
                                                    child: Image.network(
                                                      bukidModel.imageURL,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 3.0,
                                                        vertical: 3.0),
                                                // ignore: deprecated_member_use
                                                child: MaterialButton(
                                                  height: 25.0,
                                                  color: Colors.green[800],
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              CreateDetails(
                                                                userModel:
                                                                    userModel,
                                                                bukidModel:
                                                                    bukidModel,
                                                              )),
                                                    );
                                                  },
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0)),
                                                  child: const Text(
                                                      ' Create Event ',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 13)),
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                      } catch (e) {
                        return const Text("Loading");
                      }
                    }),
          );
        } catch (e) {
          return const Text("Loading");
        }
      },
    );
  }
}
