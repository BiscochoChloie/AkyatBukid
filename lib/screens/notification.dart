import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '/Services/authServices.dart';

class NotifScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text('Notifications',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                letterSpacing: 1.5,
              )),
          actions: [
            Padding(
                padding: EdgeInsets.only(top: 25, right: 30),
                child: InkWell(
                  onTap: () {},
                  child: Text('Mark as read',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orangeAccent[400],
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                      ),
                      textAlign: TextAlign.end),
                )),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.only(top: 48.0),
          decoration: BoxDecoration(color: Color(0xffefeff1)),
        ));
  }
}
