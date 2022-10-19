import 'package:akyatbukid/Models/UserModel.dart';
import 'package:akyatbukid/Models/rating_information.dart';
import 'package:akyatbukid/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '/Services/authServices.dart';
import 'package:intl/intl.dart';

class Review extends StatefulWidget {
  final List<RatingInformation> ratingInformation;


  const Review({Key? key, required this.ratingInformation})
      : super(key: key);
  @override
  ReviewState createState() => ReviewState();
}

class ReviewState extends State<Review> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Image(
          image: AssetImage('assets/images/Logo2.png'),
          width: 100.0,
          height: 100.0,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text('REVIEWS',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20,
                      letterSpacing: 5,
                      color: Colors.orangeAccent,
                    )),
              ),
              Column(

                children: widget.ratingInformation.map((rateInfo){
                  return Card(
                    child: Column(

                      children: [
                        Row(
                          mainAxisAlignment:MainAxisAlignment.spaceBetween,

                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: ClipRRect(
                                child: Image(
                                  image: AssetImage(
                                    'assets/images/placeholder.png',
                                  ),
                                  width: 30.0,
                                  height: 30.0,
                                ),
                              ),
                            ),
                            Container(
                              padding:
                              const EdgeInsets.fromLTRB(5.0, 20.0, 5.0, 20.0),
                              child: Column(
                                crossAxisAlignment:CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                    children: [
                                      StreamBuilder<DocumentSnapshot>(
                                        stream: UserController().getUser(id: rateInfo.userId),
                                        builder: (context, snapshot) {
                                          if(!snapshot.hasData)return Center();
                                          UserModel userModel = UserModel.fromDoc(doc: snapshot.data!);
                                          return Text(userModel.fname+" "+userModel.lname,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ));
                                        }
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                      ),
                                      Text(DateFormat.yMMMMd('en_US').add_jm().format(DateTime.fromMillisecondsSinceEpoch(rateInfo.timestamp)),
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(right: 220.0),
                                    child: RatingBar.builder(
                                        initialRating: rateInfo.rating,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        itemCount: 5,
                                        itemSize: 15,
                                        itemPadding:
                                        EdgeInsets.symmetric(horizontal: 2.0),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (value) {}),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.all(20),
                          child: Text(rateInfo.comment),
                        )
                      ],
                    ),
                  );
                }).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
