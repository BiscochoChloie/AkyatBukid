import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

final _fireStore = FirebaseFirestore.instance;

final usersRef = _fireStore.collection('users');

final followersRef = _fireStore.collection('followers');

final followingRef = _fireStore.collection('following');

final storageRef = FirebaseStorage.instance.ref();

final statusRef = _fireStore.collection('status');

final feedRefs = _fireStore.collection('feeds');

final likesRef = _fireStore.collection('likes');

final notificationRef = _fireStore.collection('notification');

final activitiesRef = _fireStore.collection('activities');

final eventRef = _fireStore.collection('events');

final bookRef = _fireStore.collection('bookedEvents');

const sTextFieldDecoration = InputDecoration(
    hintText: 'Enter value',
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 90.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(3.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(3.0)),
    ));

const kSendButtonTextStyle = TextStyle(
  color: Colors.green,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightGreenAccent, width: 2.0),
  ),
);

const kMessageTextFieldDecoration = InputDecoration(
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    hintText: 'Type your message here...',
    border: InputBorder.none);



enum PostStatus {
  feedPost,
}