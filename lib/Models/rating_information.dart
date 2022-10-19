import 'package:cloud_firestore/cloud_firestore.dart';
class RatingInformation {
  double rating;
  String id,userId,comment;
  int timestamp;

  RatingInformation(this.rating, this.id, this.userId, this.comment,this.timestamp);
}