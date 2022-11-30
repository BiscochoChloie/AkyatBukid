import 'dart:io';

import 'package:akyatbukid/Models/EventModel.dart';
import 'package:akyatbukid/Models/UserModel.dart';
import 'package:akyatbukid/Models/BukidModel.dart';
import 'package:akyatbukid/services/dataServices.dart';
import 'package:akyatbukid/controller/bukid_controller.dart';
import 'package:akyatbukid/controller/user_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class CreateDetails extends StatefulWidget {
  final BukidModel bukidModel;
  final UserModel userModel;

  const CreateDetails(
      {Key? key, required this.bukidModel, required this.userModel})
      : super(key: key);

  @override
  CreateDetailsState createState() => CreateDetailsState();
}

class CreateDetailsState extends State<CreateDetails> {
  final _formKey = GlobalKey<FormState>();

  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('yyyy-MM-dd – kk:mm');
  final String formatted = formatter.format(now);

  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? loggedInUser;

  InputDecoration txtDecoration(var str) {
    return InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide.none),
        filled: true,
        hintText: str,
        errorStyle:
            TextStyle(color: Colors.orange[400], fontWeight: FontWeight.bold));
  }

  void getCurrentUser() {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(user.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    authorname = '${widget.userModel.fname} ${widget.userModel.lname}';
  }

  String? _price, _packages;
  int? _noOfSlot;
  DateTime? _start;
  DateTime? _end;
  String? authorname;

  CollectionReference events = FirebaseFirestore.instance.collection('events');
  //  UserModel userModel = UserModel.fromDoc(doc: snapshot.data!);
  //User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Image(
          image: AssetImage('assets/images/Logo2.png'),
          width: 100.0,
          height: 100.0,
        ),
        centerTitle: true,
      ),
      body: Container(
        height: 800,
        color: Colors.white,
        child: ListView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 15),
          // padding: const EdgeInsets.only(top: 20.0, bottom: 15.0),
          children: [
            Center(
              child: Text(widget.bukidModel.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(0, 0, 170, 0),
                    // ignore: deprecated_member_use
                    child: MaterialButton(
                      color: Colors.green[800],
                      onPressed: () {},
                      child: const Text(' CREATE EVENT ',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Container(
                      padding: const EdgeInsets.only(top: 5.0),
                      width: 380,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(children: <Widget>[
                        const Text(
                          'Start Date & Time',
                          style: TextStyle(
                            color: Color.fromRGBO(153, 153, 153, 1.0),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 25.0, right: 20.0),
                          child: DateTimeField(
                            onChanged: (dt) => setState(() => _start = dt),
                            // onChanged: (currentValue) {
                            //   _start = currentValue as int?;
                            // },
                            format: formatter,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            onShowPicker: (context, currentValue) async {
                              final date = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime.now()
                                      .subtract(const Duration(days: 0)),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime(2100));
                              if (date != null) {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(
                                      currentValue ?? DateTime.now()),
                                );
                                return DateTimeField.combine(date, time);
                              } else {
                                return currentValue;
                              }
                            },
                          ),
                        ),
                      ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Container(
                      padding: const EdgeInsets.only(top: 5.0),
                      width: 380,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(children: <Widget>[
                        const Text(
                          'End Date & Time',
                          style: TextStyle(
                            color: Color.fromRGBO(153, 153, 153, 1.0),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 25.0, right: 20.0),
                          child: DateTimeField(
                            onChanged: (dt) => setState(() => _end = dt),
                            // onChanged: (currentValue) {
                            //   _end = currentValue! as int?;
                            // },
                            format: formatter,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            onShowPicker: (context, currentValue) async {
                              final date = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime.now()
                                      .subtract(const Duration(days: 0)),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime(2100));
                              if (date != null) {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(
                                      currentValue ?? DateTime.now()),
                                );
                                return DateTimeField.combine(date, time);
                              } else {
                                return currentValue;
                              }
                            },
                          ),
                        ),
                      ]),
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 20.0, top: 15.0, left: 20.0),
                          child: Container(
                            width: 130,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              children: [
                                const Text(
                                  'Price',
                                  style: TextStyle(
                                    color: Color.fromRGBO(153, 153, 153, 1.0),
                                  ),
                                ),
                                TextFormField(
                                  textAlign: TextAlign.center,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Price is Required';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    _price = value;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 15.0, left: 10.0, right: 15.0),
                          child: Container(
                            width: 130,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              children: [
                                const Text(
                                  'No. of Slots',
                                  style: TextStyle(
                                    color: Color.fromRGBO(153, 153, 153, 1.0),
                                  ),
                                ),
                                TextFormField(
                                  textAlign: TextAlign.center,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'No of Slots is Required';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) => setState(
                                      () => _noOfSlot = int.parse(value)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(15)),
                        width: 280,
                        height: 100,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: Column(
                                  children: [
                                    const Text(
                                      'Packages',
                                      style: TextStyle(
                                        color:
                                            Color.fromRGBO(153, 153, 153, 1.0),
                                      ),
                                    ),
                                    TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Packages is Required';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintMaxLines: 4),
                                      onChanged: (value) {
                                        _packages = value;
                                      },
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                    ),
                                  ],
                                ),
                              ),
                            ])),
                  ),
                  const SizedBox(height: 25.0),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Event Created')),
                        );
                        setState(() {
                          _isLoading = true;
                        });
                        events.add({
                          'authorId': loggedInUser?.uid,
                          'authorname': authorname,
                          'profilePicture': widget.userModel.profilePicture,
                          'timestamp':
                              DateTime.now().toIso8601String().toString(),
                          // 'timestamp': Timestamp.fromDate(DateTime.now()).toString(),
                          'name': widget.bukidModel.name,
                          'imageURL': widget.bukidModel.imageURL,
                          'description': widget.bukidModel.description,
                          'difficulty': widget.bukidModel.difficulty,
                          'hoursHike': widget.bukidModel.hoursHike,
                          'location': widget.bukidModel.location,
                          'start': _start!,
                          'end': _end!,
                          'price': _price!,
                          'noOfSlot': _noOfSlot!,
                          'packages': _packages!,
                          'ratingInformation': [],
                        });
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[800],
                        onPrimary: Colors.white,
                        padding: const EdgeInsets.fromLTRB(40, 8, 40, 8),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        textStyle: const TextStyle(
                          fontSize: 16,
                        )),
                    child: const Text('Post'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
