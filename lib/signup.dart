import 'package:akyatbukid/navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Services/authServices.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

// import 'package:akyatbukid/navbar.dart';

class SignupPage extends StatefulWidget {
  static const String id = 'signin';
  @override
  SignupPageState createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final emailExp =
      new RegExp(r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)");
  bool checkBoxValue = false;
  InputDecoration txtDecoration(var str) {
    return InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
        filled: true,
        fillColor: Color(0xFFe7edeb),
        hintText: str,
        errorStyle:
            TextStyle(color: Colors.orange[400], fontWeight: FontWeight.bold));
  }

  bool _isDisabled = false;
  bool _isLoading = false;
  var errorMessage;
  bool _passwordVisible1 = false;
  bool _passwordVisible2 = false;

  String? _email;
  String? _password;
  String? _fname;
  String? _lname;
  String? _address;
  String? _contact;
  String? _birthday;
  String? _usertype;
  String? _operatorId;

  Future submitOperator() async {
    var a = await FirebaseFirestore.instance
        .collection('tourOperator')
        .doc(_operatorId)
        .get();
    if (a.exists) {
      print('TourOperator Id exists!');
      if (_formKey.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });
        _formKey.currentState!.save();
        try {
          await AuthService.signUp(
              context,
              _email!,
              _password!,
              _fname!,
              _lname!,
              _address!,
              _contact!,
              _birthday!,
              _usertype!,
              _operatorId!);

          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Sign Up Successfully!')));
        } on PlatformException catch (e) {
          setState(() {
            _isLoading = false;
          });
          throw (e);
        }
      }
      return a;
    }
    if (!a.exists) {
      print(_operatorId);
      // 'TourOperator Id does not exists!'
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('TourOperator does not exist!')),
      );
      return null;
    }
  }

  Future submitHiker() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState!.save();
      try {
        await AuthService.signUp(context, _email!, _password!, _fname!, _lname!,
            _address!, _contact!, _birthday!, _usertype!, _operatorId = "");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign Up Successfully!')),
        );
      } on PlatformException catch (err) {
        setState(() {
          _isLoading = false;
          errorMessage = err.toString();
        });
        throw (err);
      }
    }
  }

  void initState() {
    super.initState();
    _usertype = '';
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
        backgroundColor: Color.fromRGBO(69, 95, 70, 1.0),
        body: Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Center(
                child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 50.0),
                    child: Form(
                        key: _formKey,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 30),
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
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                              TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty)
                                    return 'Email is Required';
                                  else if (emailExp.hasMatch(value) == false)
                                    return 'Invalid Email';

                                  return null;
                                },
                                keyboardType: TextInputType.emailAddress,
                                decoration: txtDecoration('Email Address'),
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
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                              TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Password is Required';
                                  } else if (value.length < 8)
                                    return 'Password must be at least 8 characters';
                                  return null;
                                },
                                keyboardType: TextInputType.visiblePassword,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none),
                                    filled: true,
                                    fillColor: Color(0xFFe7edeb),
                                    hintText: "Password",
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _passwordVisible1
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.grey[600],
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _passwordVisible1 =
                                              !_passwordVisible1;
                                        });
                                      },
                                    ),
                                    errorStyle: TextStyle(
                                        color: Colors.orange[400],
                                        fontWeight: FontWeight.bold)),
                                onChanged: (value) {
                                  _password = value;
                                },
                                obscureText: !_passwordVisible1,
                              ),
                              SizedBox(height: 8.0),
                              Container(
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.fromLTRB(5, 0, 0, 3),
                                child: Text(
                                  'Confirm Password',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                              TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty)
                                    return 'Please confirm your password';
                                  else if (value != _password)
                                    return 'Password did not match';

                                  return null;
                                },
                                keyboardType: TextInputType.visiblePassword,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none),
                                    filled: true,
                                    fillColor: Color(0xFFe7edeb),
                                    hintText: "Confirm Password",
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _passwordVisible2
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.grey[600],
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _passwordVisible2 =
                                              !_passwordVisible2;
                                        });
                                      },
                                    ),
                                    errorStyle: TextStyle(
                                        color: Colors.orange[400],
                                        fontWeight: FontWeight.bold)),
                                obscureText: !_passwordVisible2,
                              ),
                              SizedBox(height: 8.0),
                              Container(
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.fromLTRB(5, 0, 0, 3),
                                child: Text(
                                  'Full Name',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'First name is Required';
                                          }
                                          return null;
                                        },
                                        keyboardType: TextInputType.text,
                                        decoration: txtDecoration('First Name'),
                                        onChanged: (value) {
                                          _fname = value;
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 5.0),
                                    Flexible(
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Last name is Required';
                                          }
                                          return null;
                                        },
                                        keyboardType: TextInputType.text,
                                        decoration: txtDecoration('Last Name'),
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
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                              TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Address is Required';
                                  }
                                  return null;
                                },
                                decoration: txtDecoration('Brgy/City/Province'),
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
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                              TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Contact number is Required';
                                  } else if (value.length < 11)
                                    return 'Invalid Contact number';
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                decoration: txtDecoration('Contact Number'),
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
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                              TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Birthday is Required';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.datetime,
                                decoration: txtDecoration('MM/DD/YY'),
                                onChanged: (value) {
                                  _birthday = value;
                                },
                              ),
                              SizedBox(height: 20.0),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 1.5,
                                            color: Colors.black38))),
                              ),
                              SizedBox(height: 20.0),
                              Container(
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.fromLTRB(5, 0, 0, 3),
                                child: Text(
                                  'What are you? ',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                child: Row(children: [
                                  Row(children: [
                                    Radio(
                                      activeColor: Colors.orange[400],
                                      value: 'H I K E R',
                                      groupValue: _usertype,
                                      onChanged: (val) {
                                        setState(() {
                                          _usertype = val as String;
                                        });
                                      },
                                    ),
                                    Text(
                                      'Hiker',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ]),
                                  SizedBox(width: 15.0),
                                  Row(children: [
                                    Radio(
                                      activeColor: Colors.orange[400],
                                      value: 'TOUR OPERATOR',
                                      groupValue: _usertype,
                                      onChanged: (val) {
                                        setState(() {
                                          _usertype = val as String;
                                        });
                                      },
                                    ),
                                    Text(
                                      'Tour Operator',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    // Text('$_usertype', style: TextStyle(fontSize: 23),)
                                  ]),
                                ]),
                              ),
                              SizedBox(height: 15.0),
                              _usertype == null || _usertype == 'TOUR OPERATOR'
                                  ? Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.topLeft,
                                          padding:
                                              EdgeInsets.fromLTRB(5, 0, 0, 3),
                                          child: Text(
                                            'ID No.',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white),
                                          ),
                                        ),
                                        TextFormField(
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Tour Operator ID No. is Required';
                                            } else if (value.length < 5)
                                              return 'Invalid ID. No';
                                            return null;
                                          },
                                          enabled: !_isDisabled,
                                          keyboardType: TextInputType.text,
                                          decoration: txtDecoration('ID No.'),
                                          onChanged: (value) {
                                            _operatorId = value;
                                          },
                                        ),
                                      ],
                                    )
                                  : SizedBox(height: 5.0),
                              SizedBox(height: 15.0),
                              Row(
                                children: [
                                  Checkbox(
                                      activeColor: Colors.orange[400],
                                      value: checkBoxValue,
                                      onChanged: (isAccepted) {
                                        setState(() {
                                          checkBoxValue = isAccepted!;
                                        });
                                      }),
                                  Container(
                                    alignment: Alignment.centerRight,
                                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        textStyle: const TextStyle(
                                            fontSize: 14, color: Colors.white),
                                      ),
                                      onPressed: () {
                                        AwesomeDialog(
                                          context: context,
                                          headerAnimationLoop: false,
                                          dialogType: DialogType.INFO,
                                          animType: AnimType.BOTTOMSLIDE,
                                          title: 'TERMS AND CONDITIONS',
                                          desc:
                                              "1. Introduction\n Welcome to Akyat Bukid!\n"
                                              "These Terms of Service govern your use of our application operated by Akyat Bukid.\n\n"
                                              "2. Content\n Our Service allows you to post, link, store, share and otherwise make available certain "
                                              "information, text, graphics, videos, or other material.\n\n"
                                              "3. Amendments To Terms\n We may amend Terms at any time by posting the amended terms on this site. "
                                              "It is your responsibility to review these Terms periodically.\n\n"
                                              "4. Acknowledgement\n BY USING SERVICE OR OTHER SERVICES PROVIDED BY THE US, YOU ACKNOWLEDGE THAT YOU "
                                              "HAVE READ THESE TERMS OF SERVICE AND AGREE TO BE BOUND BY THEM.\n\n"
                                              "5. Contact Us\n Please send your feedback, comments, requests for technical support by email: akyatbukid@gmail.com.\n\n\n"
                                              "These Terms of Service were created for akyatbukid.com by PolicyMaker.io on 2022-01-14.",
                                        ).show();
                                      },
                                      child: const Text(
                                        'By tapping "Signup" you agree to our \nTerms & Policies ** READ MORE',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 30.0),
                              ElevatedButton(
                                onPressed: () async {
                                  _usertype == 'TOUR OPERATOR'
                                      ? submitOperator()
                                      : submitHiker();
                                },
                                child: Text('SIGNUP'),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.orange[400],
                                    onPrimary: Colors.black,
                                    padding: const EdgeInsets.fromLTRB(
                                        57, 10, 57, 10),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    textStyle: TextStyle(
                                      fontSize: 23,
                                    )),
                              ),
                            ]))))));
  }
}
