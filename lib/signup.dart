import 'package:flutter/material.dart';
import 'package:akyatbukid/navbar.dart';
import 'Services/auth_services.dart';

class SignupPage extends StatefulWidget {
  @override
  SignupPageState createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  bool checkBoxValue = false;

  String _email;
  String _password;
  String _fname;
  String _lname;
  String _address;
  String _contact;
  String _usertype = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          title: Image(
            image: AssetImage('assets/images/logo.png'),
            width: 100.0,
            height: 100.0,
          ),
          centerTitle: true,
        ),
        backgroundColor: Color.fromRGBO(69, 95, 70, 1.0),
        body: Center(
            child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 50.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                              child: Text(
                                'SIGNUP',
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.fromLTRB(5, 0, 0, 3),
                            child: Text(
                              'Email',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter email';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none),
                              filled: true,
                              fillColor: Color(0xFFe7edeb),
                              hintText: "Email Address",
                            ),
                            onChanged: (value) {
                              _email = value;
                            },
                          ),
                          SizedBox(height: 8.0),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.fromLTRB(5, 0, 0, 3),
                            child: Text(
                              'Password',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                          TextField(
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none),
                              filled: true,
                              fillColor: Color(0xFFe7edeb),
                              hintText: "Password",
                            ),
                            onChanged: (value) {
                              _password = value;
                            },
                            obscureText: true,
                          ),
                          SizedBox(height: 8.0),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.fromLTRB(5, 0, 0, 3),
                            child: Text(
                              'Full Name',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide.none),
                                      filled: true,
                                      fillColor: Color(0xFFe7edeb),
                                      hintText: "First Name",
                                    ),
                                    onChanged: (value) {
                                      _fname = value;
                                    },
                                  ),
                                ),
                                SizedBox(width: 5.0),
                                Flexible(
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide.none),
                                      filled: true,
                                      fillColor: Color(0xFFe7edeb),
                                      hintText: "Last Name",
                                    ),
                                    onChanged: (value) {
                                      _lname = value;
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.fromLTRB(5, 0, 0, 3),
                            child: Text(
                              'Address',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                          TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none),
                              filled: true,
                              fillColor: Color(0xFFe7edeb),
                              hintText: "Brgy/City/Province",
                            ),
                            onChanged: (value) {
                              _address = value;
                            },
                          ),
                          SizedBox(height: 8.0),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.fromLTRB(5, 0, 0, 3),
                            child: Text(
                              'Contact Number',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                          TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none),
                              filled: true,
                              fillColor: Color(0xFFe7edeb),
                              hintText: "Contact Number",
                            ),
                            onChanged: (value) {
                              _contact = value;
                            },
                          ),
                          SizedBox(height: 8.0),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.fromLTRB(5, 0, 0, 3),
                            child: Text(
                              'Birthday',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide.none),
                                      filled: true,
                                      fillColor: Color(0xFFe7edeb),
                                      hintText: "MM",
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5.0),
                                Flexible(
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide.none),
                                      filled: true,
                                      fillColor: Color(0xFFe7edeb),
                                      hintText: "DD",
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5.0),
                                Flexible(
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide.none),
                                      filled: true,
                                      fillColor: Color(0xFFe7edeb),
                                      hintText: "YY",
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1.5, color: Colors.black38))),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.fromLTRB(5, 0, 0, 3),
                            child: Text(
                              'What are you? ',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                          Container(
                              alignment: Alignment.topLeft,
                              child: Row(children: [
                                Row(children: [
                                  Radio(
                                    value: 'hiker',
                                    groupValue: _usertype,
                                    onChanged: (val) {
                                      setState(() {
                                        _usertype = val;
                                      });
                                    },
                                  ),
                                  Text('Hiker')
                                ]),
                                SizedBox(width: 15.0),
                                Row(children: [
                                  Radio(
                                    value: 'guide',
                                    groupValue: _usertype,
                                    onChanged: (val) {
                                      setState(() {
                                        _usertype = val;
                                      });
                                    },
                                  ),
                                  Text('Guide')
                                ]),
                              ])),
                          SizedBox(height: 30.0),
                          Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                              child: Text(
                                'By tapping "Signup" you agree to our Terms & Policies',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              )),
                          SizedBox(height: 30.0),
                          ElevatedButton(
                            onPressed: () async {
                              bool isValid = await AuthService.signUp(
                                  _email,
                                  _password,
                                  _fname,
                                  _lname,
                                  _address,
                                  _contact,
                                  _usertype);
                              if (isValid) {
                                Navigator.pop(context);
                              } else {
                                print('Something went wrong!');
                              }
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => NavPage()));
                            },
                            child: Text('SIGNUP'),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.orange[400],
                                onPrimary: Colors.black,
                                padding:
                                    const EdgeInsets.fromLTRB(57, 10, 57, 10),
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                textStyle: TextStyle(
                                  fontSize: 23,
                                )),
                          ),
                        ])))));
  }
}
