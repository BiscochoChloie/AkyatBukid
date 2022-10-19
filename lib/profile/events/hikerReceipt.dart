import 'dart:math';
import 'package:akyatbukid/Models/BookModel.dart';
import 'package:akyatbukid/Models/EventModel.dart';
import 'package:akyatbukid/Models/UserModel.dart';
import 'package:akyatbukid/bookingdetails/mtdetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';

class HikerReceipt extends StatefulWidget {
final BookModel bookModel;

  const HikerReceipt({
  required this.bookModel
  });
  @override
  HikerReceiptState createState() => HikerReceiptState();
}

class HikerReceiptState extends State<HikerReceipt> {
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
        iconTheme: IconThemeData(color: Colors.black),
        title: Image(
          image: AssetImage('assets/images/Logo2.png'),
          width: 100.0,
          height: 100.0,
        ),
        centerTitle: true,
      ),
      body: Container(
        height: 800,
        child: ListView(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 15),
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
                      child: Text(
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
                        widget.bookModel.bukidname, //RadioButtonResult
                        style: TextStyle(
                          fontSize: 20,
                          letterSpacing: 3,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Container(
                      child: Text(
                          "Departure: ${DateFormat('dd MMM, yyyy, h:mm a').format(widget.bookModel.eventstart).toString()}"
                          //Database
                          ),
                    ),
                  ),
                  Divider(
                    height: 20,
                    thickness: 2,
                    indent: 20,
                    endIndent: 20,
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: Container(
                      child: Text(
                        widget.bookModel.fname + '  ' + widget.bookModel.lname,
                        style: TextStyle(
                          fontSize: 20,
                          letterSpacing: 3,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 30.0),
                    child: Container(
                      
                      child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Address   ',
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right:30.0),
                             child: Text(
                              widget.bookModel.address,
                              // textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 30.0, top: 10.0),
                    child: Container(
                      child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Zip Code   ',
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 30.0),
                            child: Text(
                              widget.bookModel.zipCode,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 30.0, top: 10.0),
                    child: Container(
                      child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Birhtdate   ',
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 30.0),
                            child: Text(
                              widget.bookModel.birthday,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 30.0, top: 10.0),
                    child: Container(
                      child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Phone #   ',
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 30.0),
                            child: Text(
                              widget.bookModel.contact,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 30.0, top: 10.0),
                    child: Container(
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Email   ',
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 30.0),
                            child: Text(
                              widget.bookModel.email,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 20,
                    thickness: 2,
                    indent: 20,
                    endIndent: 20,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 210),
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
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 150, 0),
                          child: Container(
                            child: Text(
                              'Total Payment: ₱ ' +
                                  widget.bookModel.eventprice, //Database
                              style: TextStyle(
                                fontSize: 20,
                                color: Color.fromRGBO(500, 800, 800, 800),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 20,
                    thickness: 2,
                    indent: 20,
                    endIndent: 20,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Column(
                      children: [
                        Text(
                          'Confirmation No.:   ' + generateRandomString(12),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            formatted, //Database
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
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
