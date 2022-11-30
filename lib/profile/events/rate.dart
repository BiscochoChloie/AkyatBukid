import 'package:akyatbukid/Models/EventModel.dart';
import 'package:akyatbukid/Models/rating_information.dart';
import 'package:akyatbukid/Services/separator.dart';
import 'package:akyatbukid/controller/event_controller.dart';
import 'package:akyatbukid/profile/events/review.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Rate extends StatefulWidget {
  final EventModel eventModel;
  const Rate({required this.eventModel});

  @override
  State<Rate> createState() => _RateState();
}

class _RateState extends State<Rate> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  double? _rating;
  String _Text = "";
  @override
  void initState() {
    super.initState();
    _rating = 5;
    _Text = '';
  }

  @override
  Widget build(BuildContext context) {
    FocusNode writingTextFocus = FocusNode();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Image(
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
                child: const Text('RATE EVENT',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20,
                      letterSpacing: 5,
                      color: Colors.orangeAccent,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
                child: Text(widget.eventModel.name,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(25.0, 10.0, 0.0, 0.0),
                child: Row(
                  children: [
                    Container(
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: widget
                                .eventModel.profilePicture.isEmpty
                            ? const AssetImage('assets/images/placeholder.png')
                            : NetworkImage(widget.eventModel.profilePicture)
                                as ImageProvider,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Column(
                        children: [
                          Text(widget.eventModel.authorname,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              )),
                          const Text('event host',
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
              Container(
                padding: const EdgeInsets.only(top: 20.0),
                child: const Text('Please Rate Your Experience',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
                child: RatingBar.builder(
                    initialRating: _rating!,
                    minRating: 1,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                    itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                    onRatingUpdate: (value) {
                      _rating = value;
                    }),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5)),
                    width: 270,
                    height: 150,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: TextFormField(
                              autofocus: true,
                              focusNode: writingTextFocus,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Share your experience!',
                                  hintMaxLines: 4),
                              onChanged: (value) {
                                _Text = value;
                              },
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                            ),
                          ),
                        ])),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 3),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 3.0, vertical: 3.0),
                  // ignore: deprecated_member_use

                  child: MaterialButton(
                    height: 30.0,
                    color: Colors.green[800],
                    onPressed: () {
                      bool alreadyRated = false;
                      var uuid = const Uuid();

                      for (var element in widget.eventModel.ratingInformation) {
                        List<String> data = element
                            .toString()
                            .split(Separator.ratingInformationSeparator);

                        RatingInformation ratingInformation = RatingInformation(
                            double.parse(data[0]),
                            data[1],
                            data[2],
                            data[3],
                            int.parse(data[4]));
                        if (ratingInformation.userId ==
                            FirebaseAuth.instance.currentUser!.uid) {
                          alreadyRated = true;
                        }
                      }
                      if (!alreadyRated) {
                        widget.eventModel.ratingInformation.add(_rating
                                .toString() +
                            Separator.ratingInformationSeparator +
                            uuid.v1() +
                            Separator.ratingInformationSeparator +
                            FirebaseAuth.instance.currentUser!.uid +
                            Separator.ratingInformationSeparator +
                            _Text +
                            Separator.ratingInformationSeparator +
                            DateTime.now().millisecondsSinceEpoch.toString());
                        EventController().upSert(event: widget.eventModel);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'You have successfully rated this event!')));
                      } else {
                        //you are already rated
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('You have already rated')));
                      }
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    child: const Text(' Submit Rate ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
