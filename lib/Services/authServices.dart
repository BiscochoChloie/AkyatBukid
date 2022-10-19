import 'package:akyatbukid/Models/UserModel.dart';
import 'package:akyatbukid/navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final _fireStore = FirebaseFirestore.instance;
  static Future<void> signUp(
      BuildContext context,
      String email,
      String password,
      String fname,
      String lname,
      String address,
      String contact,
      String birthday,
      String usertype,
      String operatorId) async {
    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User? signedInUser = authResult.user;

      if (signedInUser != null) {
        _fireStore.collection('users').doc(signedInUser.uid).set({
          'email': email,
          'fname': fname,
          'lname': lname,
          'address': address,
          'contact': contact,
          'birthday': birthday,
          'usertype': usertype,
          'profilePicture': '',
          'bio': '',
          'operatorId': operatorId
        });
      }
Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NavPage(userModel: UserModel(uid: signedInUser!.uid, email: email, fname: fname, lname: lname, address: address, contact: contact, birthday: birthday, usertype: usertype, profilePicture: '', bio: '', operatorId: operatorId) )),
        );
      //  Navigator.pop(context);
    } on PlatformException catch (e) {
      throw (e);
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  static Future logout() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
