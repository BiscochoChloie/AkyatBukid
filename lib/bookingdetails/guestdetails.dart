import 'package:akyatbukid/Models/EventModel.dart';
import 'package:akyatbukid/Models/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:akyatbukid/bookingdetails/receipt.dart';

class GuestDetails extends StatefulWidget {
  final EventModel eventModel;
  final UserModel user;
  final eventId, bukidname, eventprice, eventstart, eventend;

  GuestDetails(
      {Key? key,
      required this.eventModel,
      required this.user,
      required this.eventId,
      required this.bukidname,
      required this.eventprice,
      required this.eventstart,
      required this.eventend})
      : super(key: key);
  @override
  GuestDetailsState createState() => GuestDetailsState();
}

class GuestDetailsState extends State<GuestDetails> {
  User? user = FirebaseAuth.instance.currentUser;
  GlobalKey<FormState> _formKey = GlobalKey();
  String? _eventId;
  String? _bukidname;
  String? _eventprice;
  DateTime? _eventstart;
  DateTime? _eventend;
  String? _authorId;
  String? _fname;
  String? _lname;
  String? _profilePicture;
  String? _address;
  String? _zipcode;
  String? _birthday;
  String? _contact;
  String? _email;

  @override
  void initState() {
    super.initState();
    _eventId = widget.eventId;
    _bukidname = widget.bukidname;
    _eventprice = widget.eventprice;
    _eventstart = widget.eventstart;
    _eventend = widget.eventend;
    _authorId = widget.user.uid;
    _fname = widget.user.fname;
    _lname = widget.user.lname;
    _profilePicture = widget.user.profilePicture;
    _address = widget.user.address;
    _zipcode = '';
    _birthday = widget.user.birthday;
    _contact = widget.user.contact;
    _email = widget.user.email;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 15),
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Center(
                child: Text(widget.bukidname,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 30, 200, 10),
                child: Container(
                  alignment: Alignment.center,
                  height: 25,
                  color: Colors.green[800],
                  child: Text(
                    '   GUEST DETAILS   ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 5, 0, 5),
                child: Text(
                  'Name',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(right: 3),
                      width: 170,
                      child: TextFormField(
                        initialValue: _fname,
                        key: Key(_fname!),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'First Name',
                          fillColor: Colors.grey.shade300,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide.none),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter First Name';
                          }

                          return null;
                        },
                        onChanged: (value) {
                          _fname = value;
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 3),
                      width: 165,
                      child: TextFormField(
                        initialValue: _lname,
                        key: Key(_lname!),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'Last Name',
                          fillColor: Colors.grey.shade300,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide.none),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Last Name';
                          }

                          return null;
                        },
                        onChanged: (value) {
                          _lname = value;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 5, 0, 5),
                child: Text(
                  'Address',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: TextFormField(
                  initialValue: _address,
                  key: Key(_address!),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Street/Barangay/City/Province',
                    fillColor: Colors.grey.shade300,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Address';
                    }

                    return null;
                  },
                  onChanged: (value) {
                    _address = value;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 5, 0, 5),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(right: 3),
                      width: 190,
                      child: Text(
                        'Zip Code',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Container(
                      // padding: const EdgeInsets.only(left: 3),
                      width: 130,
                      child: Text(
                        'Birthdate',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(right: 3),
                      width: 165,
                      child: TextFormField(
                        initialValue: _zipcode,
                        key: Key(_zipcode!),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Zip Code',
                          fillColor: Colors.grey.shade300,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide.none),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Zip Code';
                          }

                          return null;
                        },
                        onChanged: (value) {
                          _zipcode = value;
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10),
                      width: 165,
                      child: TextFormField(
                        initialValue: _birthday,
                        key: Key(_birthday!),
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                          hintText: 'Birthdate',
                          fillColor: Colors.grey.shade300,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide.none),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Birthdate';
                          }

                          return null;
                        },
                        onChanged: (value) {
                          _birthday = value;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 5, 0, 5),
                child: Text(
                  'Contact Number',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: TextFormField(
                  initialValue: _contact,
                  key: Key(_contact!),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Contact Number',
                    fillColor: Colors.grey.shade300,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Contact Number';
                    }

                    return null;
                  },
                  onChanged: (value) {
                    widget.user.contact = value;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 5, 0, 5),
                child: Text(
                  'Email',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: TextFormField(
                  initialValue: _email,
                  key: Key(_email!),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    fillColor: Colors.grey.shade300,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Email';
                    }

                    return null;
                  },
                  onChanged: (value) {
                    _email = value;
                  },
                ),
              ),
              // GestureDetector(
              //   onTap: () {},
              //   child: Padding(
              //     padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
              //     child: Text(
              //       'Book Companion',
              //       textAlign: TextAlign.end,
              //       style: TextStyle(
              //         fontWeight: FontWeight.normal,
              //         fontSize: 15,
              //       ),
              //     ),
              //   ),
              // ),
              Divider(
                height: 20,
                thickness: 2,
                indent: 20,
                endIndent: 20,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 3.0, vertical: 3.0),
                  // ignore: deprecated_member_use

                  child: FlatButton(
                    height: 30.0,
                    color: Colors.green[800],
                    onPressed: () async {
                      print(_authorId);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Receipt(
                            eventId: _eventId,
                            bukidname: _bukidname!,
                            eventprice: _eventprice!,
                            eventstart: _eventstart!,
                            eventend: _eventend!,
                            outputAuthorId: _authorId,
                            outputfname: _fname!.toUpperCase(),
                            outputlname: _lname!.toUpperCase(),
                            outputProfilePicture: _profilePicture!,
                            outputAdd: _address!,
                            outputZipCode: _zipcode!,
                            outputBirth: _birthday!,
                            outputPhone: _contact!,
                            outputEmail: _email!,
                            eventModel: widget.eventModel,
                            user: widget.user,
                          ),

                          // AddCompanion(// bookModel: widget.bookModel,)
                        ),
                      );
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Text(' Proceed ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        )),
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
