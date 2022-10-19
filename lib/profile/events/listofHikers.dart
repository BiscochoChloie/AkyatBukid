import 'package:akyatbukid/Models/BookModel.dart';
import 'package:akyatbukid/Models/EventModel.dart';

import 'package:akyatbukid/Models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:akyatbukid/controller/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';

class ListofHikers extends StatefulWidget {
  final EventModel eventModel;

  const ListofHikers({Key? key, required this.eventModel}) : super(key: key);
  @override
  _ListofHikersState createState() => _ListofHikersState();
}

class _ListofHikersState extends State<ListofHikers> {
  User? user = FirebaseAuth.instance.currentUser;

  static final DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot<Map<String, dynamic>>> listofHikers =
        FirebaseFirestore.instance
            .collection('bookedEvents')
            .where("eventId", isEqualTo: widget.eventModel.id)
            // .where("eventend",isLessThanOrEqualTo: now)
            // .orderBy("eventend")
            .snapshots();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Image(
          image: AssetImage('assets/images/Logo2.png'),
          width: 100.0,
          height: 100.0,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
               SizedBox(height: 10),
              Text("List of Participants",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(height: 10),
              Container(
                height: 600,
                child: StreamBuilder<QuerySnapshot>(
                    stream: listofHikers,
                    builder: (context, snapshot) {
                      try {
                        if (!snapshot.hasData) return Text("Loading");
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              BookModel bookModel = BookModel.fromDoc(
                                  doc: snapshot.data!.docs[index]);
                              BookModel.fromDoc(
                                  doc: snapshot.data!.docs[index]);

                              return Card(
                                elevation: 5.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      radius: 25.0,
                                      backgroundColor: Colors.grey,
                                      backgroundImage: bookModel
                                              .profilePicture.isEmpty
                                          ? AssetImage(
                                              'assets/images/placeholder.png')
                                          : NetworkImage(
                                                  bookModel.profilePicture)
                                              as ImageProvider,
                                    ),
                                    title: Row(
                                      children: [
                                        Text(bookModel.fname +
                                            ' ' +
                                            bookModel.lname),
                                        // UserBadges(user: user, size: 15),
                                      ],
                                    ),
                                    // subtitle: Text(user.usertype,
                                    //     style: TextStyle(
                                    //         fontSize: 11,
                                    //         fontWeight: FontWeight.bold)),
                                    // onTap: () => _goToUserProfile(context, user),
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
          ),
        ),
      ),
    );
  }
}
