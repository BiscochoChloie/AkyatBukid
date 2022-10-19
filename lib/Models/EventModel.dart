import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  String id, authorId, authorname, profilePicture;
  String timestamp;
  String name,
      imageURL,
      description,
      difficulty,
      hoursHike,
      location,
      price,
      packages;
  int noOfSlot;
  DateTime start, end;
  List<dynamic> ratingInformation;// rating,kung kinsa ang nag rate(id), commecnt;

  EventModel({
    required this.id,
    required this.authorId,
    required this.authorname,
    required this.profilePicture,
    required this.timestamp,
    required this.name,
    required this.imageURL,
    required this.description,
    required this.difficulty,
    required this.hoursHike,
    required this.location,
    required this.start,
    required this.end,
    required this.price,
    required this.noOfSlot,
    required this.packages,
    required this.ratingInformation,
  });

  factory EventModel.fromDoc({required DocumentSnapshot doc}) {

    return EventModel(
      id: doc.id,
      authorId: doc["authorId"],
      authorname: doc["authorname"],
      profilePicture: doc["profilePicture"],
      timestamp: doc["timestamp"],
      name: doc["name"],
      imageURL: doc["imageURL"],
      description: doc["description"],
      difficulty: doc["difficulty"],
      hoursHike: doc["hoursHike"],
      location: doc["location"],
      start: doc["start"].toDate(),
      end: doc["end"].toDate(),
      price: doc["price"],
      noOfSlot: doc["noOfSlot"],
      packages: doc["packages"],
      ratingInformation: doc["ratingInformation"],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'authorId': authorId,
      'authorname': authorname,
      'profilePicture': profilePicture,
      'timestamp':timestamp,
      'name': name,
      'imageURL': imageURL,
      'description': description,
      'difficulty': difficulty,
      'hoursHike': hoursHike,
      'location': location,
      'start': start,
      'end':end,
      'price':price,
      'noOfSlot': noOfSlot,
      'packages':packages,
      'ratingInformation': ratingInformation,
    };
  }
}
