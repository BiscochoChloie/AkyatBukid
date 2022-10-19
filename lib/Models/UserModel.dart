import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  String email;
  String fname;
  String lname;
  String address;
  String contact;
  String birthday;
  String usertype;
  String profilePicture;
  String bio;
  String operatorId;

  UserModel({
    required this.uid,
    required this.email,
    required this.fname,
    required this.lname,
    required this.address,
    required this.contact,
    required this.birthday,
    required this.usertype,
    required this.profilePicture,
    required this.bio,
    required this.operatorId,
  });

  factory UserModel.fromDoc({required DocumentSnapshot doc}) {
    return UserModel(
      uid: doc.id,
      email: doc['email'],
      fname: doc['fname'],
      lname: doc['lname'],
      address: doc['address'],
      contact: doc['contact'],
      birthday: doc['birthday'],
      usertype: doc['usertype'],
      profilePicture: doc['profilePicture'],
      bio: doc['bio'],
      operatorId: doc['operatorId'],
    );
  }
  factory UserModel.fromDocD({required Map<String, dynamic> doc}) {
    // print(doc['uid']);
    // print(doc['fname']);
    // print(doc['lname']);
    // print(doc['address']);
    // print(doc['email']);
    // print(doc['contact']);
    // print(doc['birthday']);
    // print(doc['usertype']);
    // print(doc['profilePicture']);
    // print(doc['bio']);
    // print(doc['operatorId']);
    print(doc);

    return UserModel(
      uid: doc['uid'],
      email: doc['email'],
      fname: doc['fname'],
      lname: doc['lname'],
      address: doc['address'],
      contact: doc['contact'],
      birthday: doc['birthday'],
      usertype: doc['usertype'],
      profilePicture: doc['profilePicture'],
      bio: doc['bio'],
      operatorId: doc['operatorId'],
    );
  }
}
