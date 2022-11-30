import 'dart:math';
import 'package:akyatbukid/Models/EventModel.dart';
import 'package:akyatbukid/Models/UserModel.dart';
import 'package:akyatbukid/bookingdetails/mtdetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';

class Receipt extends StatefulWidget {
  final eventId;
  final bukidname;
  final eventprice;
  final eventstart;
  final eventend;
  final outputAuthorId;
  final outputfname;
  final outputlname;
  final outputProfilePicture;
  final outputAdd;
  final outputZipCode;
  final outputBirth;
  final outputPhone;
  final outputEmail;
  final EventModel eventModel;
  final UserModel user;

  const Receipt({
    @required this.eventId,
    this.bukidname,
    this.eventprice,
    this.eventstart,
    this.eventend,
    this.outputAuthorId,
    this.outputfname,
    this.outputlname,
    this.outputProfilePicture,
    this.outputAdd,
    this.outputZipCode,
    this.outputBirth,
    this.outputPhone,
    this.outputEmail,
    required this.eventModel,
    required this.user,
  });
  @override
  ReceiptState createState() => ReceiptState();
}

class ReceiptState extends State<Receipt> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('E, D LLL h:mm a');
  final String formatted = formatter.format(now);

  String generateRandomString(int length) {
    final _random = Random();
    const _availableChars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final randomString = List.generate(length,
            (index) => _availableChars[_random.nextInt(_availableChars.length)])
        .join();

    return randomString;
  }

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
      body: SizedBox(
        height: 800,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 15),
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 220, 10),
                    child: Container(
                      alignment: Alignment.center,
                      height: 25,
                      color: Colors.green[800],
                      child: const Text(
                        '   RECEIPT   ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Container(
                      child: Text(
                        widget.bukidname, //RadioButtonResult
                        style: const TextStyle(
                          fontSize: 20,
                          letterSpacing: 3,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Container(
                      child: Text(
                          "Departure: ${DateFormat('dd MMM, yyyy, h:mm a').format(widget.eventstart).toString()}"
                          //Database
                          ),
                    ),
                  ),
                  const Divider(
                    height: 20,
                    thickness: 2,
                    indent: 20,
                    endIndent: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20.0),
                    child: Container(
                      child: Text(
                        widget.outputfname + '  ' + widget.outputlname,
                        style: const TextStyle(
                          fontSize: 20,
                          letterSpacing: 3,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 30.0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Address   ',
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 30.0),
                            child: Text(
                              widget.outputAdd,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 30.0, top: 10.0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Zip Code   ',
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 30.0),
                            child: Text(
                              widget.outputZipCode,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 30.0, top: 10.0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Birhtdate   ',
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 30.0),
                            child: Text(
                              widget.outputBirth,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 30.0, top: 10.0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Phone #   ',
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 30.0),
                            child: Text(
                              widget.outputPhone,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 30.0, top: 10.0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Email   ',
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 30.0),
                            child: Text(
                              widget.outputEmail,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    height: 20,
                    thickness: 2,
                    indent: 20,
                    endIndent: 20,
                  ),
                  Container(
                    child: const Padding(
                      padding: EdgeInsets.only(right: 210),
                      child: Text(
                        'PAYMENT SUMMARY',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 150, 0),
                          child: Container(
                            child: Text(
                              'Total Payment: ₱ ' +
                                  widget.eventprice, //Database
                              style: const TextStyle(
                                fontSize: 20,
                                color: Color.fromRGBO(500, 800, 800, 800),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 20,
                    thickness: 2,
                    indent: 20,
                    endIndent: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Column(
                      children: [
                        Text(
                          'Confirmation No.:   ' + generateRandomString(12),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            formatted, //Database
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: MaterialButton(
                      height: 25.0,
                      color: Colors.green[800],
                      onPressed: () async {
                        print(widget.outputAuthorId);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Successfully Booked!')),
                        );
                        //  final outputfname;
                        //   final outputlname;
                        //   final outputAdd;
                        //   final outputZipCode;
                        //   final outputBirth;
                        //   final outputPhone;
                        //   final outputEmail;

                        var db = FirebaseFirestore.instance
                            .collection('bookedEvents');
                        db.add({
                          'eventId': widget.eventId,
                          'bukidname': widget.bukidname,
                          'eventprice': widget.eventprice,
                          'eventstart': widget.eventstart,
                          'eventend': widget.eventend,
                          'authorId': widget.outputAuthorId,
                          'fname': widget.outputfname,
                          'lname': widget.outputlname,
                          'profilePicture': widget.outputProfilePicture,
                          'address': widget.outputAdd,
                          'zipCode': widget.outputZipCode,
                          'birthday': widget.outputBirth,
                          'contact': widget.outputPhone,
                          'email': widget.outputEmail,
                          // 'name': widget.bukidModel.name,
                        });
                        // Navigator.pop(context);

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return MtDetails(widget.eventModel, widget.user);
                          }),
                        );
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      child: const Text(' CONFIRM ',
                          style: TextStyle(color: Colors.white, fontSize: 13)),
                    ),
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
