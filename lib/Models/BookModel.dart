import 'package:cloud_firestore/cloud_firestore.dart';

class BookModel {
  String id;
  String eventId;
  String bukidname;
  String eventprice;
  DateTime eventstart;
  DateTime eventend;
  String authorId;
  String fname;
  String lname;
  String profilePicture;
  String address;
  String zipCode;
  String birthday;
  String contact;
  String email;

  BookModel({
    required this.id,
    required this.eventId,
    required this.bukidname,
    required this.eventprice,
    required this.eventstart,
    required this.eventend,
    required this.authorId,
    required this.fname,
    required this.lname,
    required this.profilePicture,
    required this.address,
    required this.zipCode,
    required this.birthday,
    required this.contact,
    required this.email,
  });

  factory BookModel.fromDoc({required DocumentSnapshot doc}) {
    return BookModel(
      id: doc.id,
      eventId: doc['eventId'],
      bukidname: doc['bukidname'],
      eventprice: doc['eventprice'],
      eventstart: doc['eventstart'].toDate(),
      eventend: doc['eventend'].toDate(),
      authorId: doc['authorId'],
      fname: doc['fname'],
      lname: doc['lname'],
      profilePicture: doc['profilePicture'],
      address: doc['address'],
      zipCode: doc['zipCode'],
      birthday: doc['birthday'],
      contact: doc['contact'],
      email: doc['email'],
    );
  }
}
