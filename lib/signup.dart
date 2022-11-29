import 'package:akyatbukid/constant/labels.dart';
import 'package:akyatbukid/widgets/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/authServices.dart';
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
      RegExp(r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)');
  bool checkBoxValue = false;
  InputDecoration txtDecoration(var str) {
    return InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
        filled: true,
        fillColor: const Color(0xFFe7edeb),
        hintText: str,
        errorStyle:
            TextStyle(color: Colors.orange[400], fontWeight: FontWeight.bold));
  }

  final bool _isDisabled = false;
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
          // ignore: use_build_context_synchronously
          AuthService.signUp(context, _email!, _password!, _fname!, _lname!,
              _address!, _contact!, _birthday!, _usertype!, _operatorId!);

          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Sign Up Successfully!')));
        } on PlatformException {
          setState(() {
            _isLoading = false;
          });
          rethrow;
        }
      }
      return a;
    }
    if (!a.exists) {
      print(_operatorId);
      // 'TourOperator Id does not exists!'
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('TourOperator does not exist!')),
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
            _address!, _contact!, _birthday!, _usertype!, _operatorId = '');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign Up Successfully!')),
        );
      } on PlatformException catch (err) {
        setState(() {
          _isLoading = false;
          errorMessage = err.toString();
        });
        rethrow;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _usertype = '';
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
        backgroundColor: const Color.fromRGBO(69, 95, 70, 1.0),
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
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                                child: const TextWidget(
                                    text: 'SIGNUP',
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Email is Required';
                                  } else if (emailExp.hasMatch(value) ==
                                      false) {
                                    return 'Invalid Email';
                                  }

                                  return null;
                                },
                                keyboardType: TextInputType.emailAddress,
                                decoration: txtDecoration('Email Address'),
                                onChanged: (value) {
                                  _email = value;
                                },
                              ),
                              const SizedBox(height: 8.0),
                              TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Password is Required';
                                  } else if (value.length < 8) {
                                    return 'Password must be at least 8 characters';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.visiblePassword,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none),
                                    filled: true,
                                    fillColor: const Color(0xFFe7edeb),
                                    hintText: 'Password',
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
                              const SizedBox(height: 8.0),
                              TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please confirm your password';
                                  } else if (value != _password) {
                                    return 'Password did not match';
                                  }

                                  return null;
                                },
                                keyboardType: TextInputType.visiblePassword,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none),
                                    filled: true,
                                    fillColor: const Color(0xFFe7edeb),
                                    hintText: 'Confirm Password',
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
                              const SizedBox(height: 8.0),
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
                                    const SizedBox(width: 5.0),
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
                              const SizedBox(height: 8.0),
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
                              const SizedBox(height: 8.0),
                              TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Contact number is Required';
                                  } else if (value.length < 11) {
                                    return 'Invalid Contact number';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                decoration: txtDecoration('Contact Number'),
                                onChanged: (value) {
                                  _contact = value;
                                },
                              ),
                              const SizedBox(height: 8.0),
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
                              const SizedBox(height: 20.0),
                              Container(
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 1.5,
                                            color: Colors.black38))),
                              ),
                              const SizedBox(height: 20.0),
                              Container(
                                alignment: Alignment.topLeft,
                                padding: const EdgeInsets.fromLTRB(5, 0, 0, 3),
                                child: const Text(
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
                                    const Text(
                                      'Hiker',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ]),
                                  const SizedBox(width: 15.0),
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
                                    const Text(
                                      'Tour Operator',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    // Text('$_usertype', style: TextStyle(fontSize: 23),)
                                  ]),
                                ]),
                              ),
                              const SizedBox(height: 15.0),
                              _usertype == null || _usertype == 'TOUR OPERATOR'
                                  ? Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.topLeft,
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 0, 0, 3),
                                          child: const Text(
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
                                            } else if (value.length < 5) {
                                              return 'Invalid ID. No';
                                            }
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
                                  : const SizedBox(height: 5.0),
                              const SizedBox(height: 15.0),
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
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        textStyle: const TextStyle(
                                            fontSize: 14, color: Colors.white),
                                      ),
                                      onPressed: () {
                                        AwesomeDialog(
                                          context: context,
                                          headerAnimationLoop: false,
                                          dialogType: DialogType.info,
                                          animType: AnimType.bottomSlide,
                                          title: Labels.termAndCondition,
                                          desc: Labels
                                              .termsAndConditionDescription,
                                        ).show();
                                      },
                                      child: const Text(
                                        'By tapping "Signup" you agree to our \nTerms & Policies',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30.0),
                              ElevatedButton(
                                onPressed: () async {
                                  _usertype == 'TOUR OPERATOR'
                                      ? submitOperator()
                                      : submitHiker();
                                },
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.black,
                                    backgroundColor: const Color(0xFFFFA726),
                                    padding: const EdgeInsets.fromLTRB(
                                        57, 10, 57, 10),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    textStyle: const TextStyle(
                                      fontSize: 23,
                                    )),
                                child: const Text('SIGNUP'),
                              ),
                            ]))))));
  }
}
