import 'package:cloud_firestore/cloud_firestore.dart';

class BukidModel {
  final String id,
      name,
      description,
      imageURL , difficulty, hoursHike, location;

  BukidModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageURL,
    required this.difficulty,
    required this.hoursHike,
    required this.location,
  });

  factory BukidModel.fromDoc({required DocumentSnapshot doc}) {
    return BukidModel(
      id: doc.id,
      name: doc["name"],
      description: doc["description"],
      imageURL: doc["imageURL"],
      difficulty: doc["difficulty"],
      hoursHike: doc["hoursHike"],
      location: doc["location"],
    );
  }
}
