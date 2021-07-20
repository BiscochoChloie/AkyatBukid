import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String email;
  String fname;
  String lname;
  String address;
  String contact;
  // String birthday;
  String usertype;
  String profilePicture;
  String bio;

  UserModel(
      {this.id,
  this.email,
  this.fname,
  this.lname,
  this.address,
  this.contact,
  // this.birthday,
  this.usertype,
  this.profilePicture,
  this.bio,
  });

  factory UserModel.fromDoc(DocumentSnapshot docs) {
    return UserModel(
      id: docs.id,
      email: docs['email'],
      fname: docs['fname'],
      lname: docs['lname'],
      address: docs['address'],
      contact: docs['contact'],
      usertype: docs['usertype'],
      profilePicture: docs['profilePicture'],
      bio: docs['bio'],
    );
  }
}
