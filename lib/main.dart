import 'package:akyatbukid/Models/UserModel.dart';
import 'package:akyatbukid/Services/dataServices.dart';
import 'package:akyatbukid/login.dart';
import 'package:akyatbukid/navbar.dart';
import 'package:akyatbukid/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {

  @mustCallSuper
  void initState() {

  }

  Widget getScreenId() {

    if (FirebaseAuth.instance.currentUser != null) {
      return FutureBuilder<UserModel>(
          future: DatabaseServices.getUserWithId(
              FirebaseAuth.instance.currentUser!.uid),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              return NavPage(userModel: snapshot.data!);
            }
            return Center();
          });
    } else {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: HomePage(),
          routes: {
            SignupPage.id: (context) => SignupPage(),
            LoginPage.id: (context) => LoginPage(),
          });
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: getScreenId(),
      // ),
    );
  }
}
