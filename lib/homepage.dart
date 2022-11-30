import 'package:flutter/material.dart';
import 'package:akyatbukid/login.dart';
import 'package:akyatbukid/signup.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        toolbarHeight: 0,
      ),
      backgroundColor: const Color.fromRGBO(69, 95, 70, 1.0),
      body: Column(children: <Widget>[
        const Image(image: AssetImage("assets/images/Logo1.png")),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange[400],
              onPrimary: Colors.black,
              padding: const EdgeInsets.fromLTRB(57, 10, 57, 10),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              textStyle: const TextStyle(
                fontSize: 23,
              )),
          child: const Text('LOGIN'),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange[400],
              onPrimary: Colors.black,
              padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              textStyle: const TextStyle(fontSize: 23)),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SignupPage()));
          },
          child: Text(
            'SIGNUP',
          ),
        )
      ]),
    );
  }
}
