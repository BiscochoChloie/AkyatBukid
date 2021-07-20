import 'package:flutter/material.dart';
import 'package:akyatbukid/signup.dart';
import 'package:akyatbukid/navbar.dart';
import 'Services/auth_services.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  String _email;
  String _password;
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
          padding: const EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 30.0),
          child: Form(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Color(0xFFe7edeb),
                      hintText: "Email",
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.grey[600],
                      ),
                    ),
                    onChanged: (value) {
                      _email = value;
                    },
                  ),
                  SizedBox(height: 15.0),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none),
                        filled: true,
                        fillColor: Color(0xFFe7edeb),
                        hintText: "Password",
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.grey[600],
                        )),
                    obscureText: true,
                    onChanged: (value) {
                      _password = value;
                    },
                  ),
                  SizedBox(height: 50.0),
                  ElevatedButton(
                    onPressed: () async {
                      bool isValid = await AuthService.login(
                        _email,
                        _password,
                      );
                      if (isValid) {
                        Navigator.pop(context);
                      } else {
                        print('Something went wrong!');
                      }
                    },
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => NavPage()));

                    child: Text('LOGIN'),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.orange[400],
                        onPrimary: Colors.black,
                        padding: const EdgeInsets.fromLTRB(57, 10, 57, 10),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        textStyle: TextStyle(
                          fontSize: 23,
                        )),
                  ),
                  SizedBox(height: 60.0),
                  InkWell(
                    onTap: () {},
                    child: Text('Forgot Password?',
                        style: TextStyle(
                          color: Colors.grey[100],
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                        textAlign: TextAlign.end),
                  ),
                  SizedBox(height: 20.0),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignupPage()));
                    },
                    child: Text('Create an Account',
                        style: TextStyle(
                          color: Colors.grey[100],
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                        textAlign: TextAlign.end),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
