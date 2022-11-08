import 'package:akyatbukid/Models/EventModel.dart';
import 'package:akyatbukid/Models/UserModel.dart';
import 'package:akyatbukid/Services/dataServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:akyatbukid/bookingdetails/guestdetails.dart';
import 'package:intl/intl.dart';

class MtDetails extends StatefulWidget {
  // final int index;
  final EventModel eventModel;
  final UserModel user;

  MtDetails(
    this.eventModel,
    this.user,
  );

  @override
  State<MtDetails> createState() => _MtDetailsState();
}

class _MtDetailsState extends State<MtDetails> {
  User? user = FirebaseAuth.instance.currentUser;

  int _bookedCount = 0;
  int _remainingSlot = 0;
  String? bookfor;

  getBookedCount() async {
    int bookedCount = await DatabaseServices.bookedNum(widget.eventModel.id);
    if (mounted) {
      setState(() {
        _bookedCount = bookedCount;
      });
    }
  }

  remainingSlot() async {
    int remainingSlot =
        await DatabaseServices.remainingSlot(widget.eventModel.id);
    if (mounted) {
      setState(() {
        _remainingSlot = widget.eventModel.noOfSlot - remainingSlot;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getBookedCount();
    remainingSlot();
  }

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
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 20.0),
                        width: 410.0,
                        child: Center(
                          child: ClipRRect(
                            child: Image.network(
                              widget.eventModel.imageURL,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      Text(widget.eventModel.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                      Divider(),
                      Container(
                        height: 120.0,
                        width: 350.0,
                        child: Text(
                          widget.eventModel.description,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Divider(
                        height: 10,
                        color: Colors.grey,
                      ),
                      Container(
                        padding: const EdgeInsets.all(3),
                        child: Text('No. Participants $_bookedCount',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      Container(
                        child: Text('Remaining Slot $_remainingSlot',
                            style: TextStyle(
                              color: Colors.red[300],
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      Container(
                        padding:
                            const EdgeInsets.fromLTRB(0.0, 0.0, 250.0, 0.0),
                        child: Row(
                          children: [
                            Center(
                              child: CircleAvatar(
                                radius: 20,
                                backgroundImage: widget
                                        .user.profilePicture.isEmpty
                                    ? AssetImage(
                                        'assets/images/placeholder.png')
                                    : NetworkImage(
                                            widget.eventModel.profilePicture)
                                        as ImageProvider,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(5.0, 0.0, 1.0, 0.0),
                              child: Column(
                                children: [
                                  Text(widget.eventModel.authorname,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  Text('event host',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 12,
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 10,
                        color: Colors.grey,
                      ),
                      Container(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 10.0, 150.0, 5.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on_sharp,
                              color: Colors.green,
                              size: 30.0,
                            ),
                            Text(widget.eventModel.location,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 0.0, 320.0, 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.hiking_sharp,
                              color: Colors.green,
                              size: 30.0,
                            ),
                            Text(widget.eventModel.difficulty,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                      ),
                      Container(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 0.0, 280.0, 5.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.watch_later_sharp,
                              color: Colors.green,
                              size: 30.0,
                            ),
                            Text(widget.eventModel.hoursHike,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 5.0),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 0.0, 100.0, 5.0),
                              child: Row(
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.price_change_sharp,
                                          color: Colors.green,
                                          size: 30.0,
                                        ),
                                        Text('₱ ' + widget.eventModel.price,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            )),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        100.0, 0.0, 0.0, 0.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_today_sharp,
                                          color: Colors.green,
                                          size: 30.0,
                                        ),
                                        Text(
                                            "${DateFormat('MMM dd, yyyy').format(widget.eventModel.start).toString()}",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 0.0, 100.0, 5.0),
                              child: Row(
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.person_sharp,
                                          color: Colors.green,
                                          size: 30.0,
                                        ),
                                        Text(
                                            widget.eventModel.noOfSlot
                                                .toString(),
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            )),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        130.0, 0.0, 0.0, 0.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_today_sharp,
                                          color: Colors.red,
                                          size: 30.0,
                                        ),
                                        Text(
                                            "${DateFormat('MMM dd, yyyy').format(widget.eventModel.end).toString()}",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 0.0, 280.0, 5.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.backpack_sharp,
                              color: Colors.green,
                              size: 30.0,
                            ),
                            Text('Packages:',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                      ),
                      Container(
                        padding:
                            const EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 5.0),
                        height: 100,
                        width: 350,
                        color: Colors.green,
                        child: Text(widget.eventModel.packages,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      Divider(),
                      _remainingSlot == 0
                          ? MaterialButton(
                              height: 30.0,
                              color: Colors.green[800],
                              onPressed: null,
                              disabledColor: Colors.black12,
                              disabledTextColor: Colors.blueGrey,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: Text('Fully Booked!',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15)),
                            )
                          : MaterialButton(
                              height: 30.0,
                              color: Colors.green[800],
                              onPressed: () {
                                print(widget.user.uid);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          // MyApp()
                                          GuestDetails(
                                            user: widget.user,
                                            eventId: widget.eventModel.id,
                                            bukidname: widget.eventModel.name,
                                            eventprice: widget.eventModel.price,
                                            eventstart: widget.eventModel.start,
                                            eventend: widget.eventModel.end,
                                            eventModel: widget.eventModel,
                                          )),
                                );
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: Text('Join Event',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15)),
                            )
                    ],
                  )
                ]),
          ),
        ));
  }
}
