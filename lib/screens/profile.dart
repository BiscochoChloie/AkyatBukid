import 'package:akyatbukid/profile/events/HikerCompletedEvent.dart';
import 'package:akyatbukid/profile/events/HikerUpcomingEvent.dart';
import 'package:akyatbukid/Models/EventModel.dart';
import 'package:akyatbukid/Models/StatusModel.dart';
import 'package:akyatbukid/Models/UserModel.dart';
import 'package:akyatbukid/profile/events/OperatorCompletedEvent.dart';
import 'package:akyatbukid/profile/events/OperatorUpcomingEvent.dart';
import 'package:akyatbukid/Services/authServices.dart';
import 'package:akyatbukid/Services/dataServices.dart';
import 'package:akyatbukid/constant/constant.dart';
import 'package:akyatbukid/controller/user_controller.dart';
import 'package:akyatbukid/profile/mediaContainer.dart';
import 'package:akyatbukid/newsfeed/statusContainer.dart';
import 'package:akyatbukid/profile/peers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:akyatbukid/profile/editprofile.dart';

import '../homepage.dart';

class ProfilePage extends StatefulWidget {
  static const String id = 'profile';
  final UserModel userModel;
  const ProfilePage({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  int _followersCount = 0;
  int _followingCount = 0;
  bool _isFollowing = false;
  int _profileSegmentedValue = 0;
  List<StatusModel> _allStatus = [];
  List<StatusModel> _mediaStatus = [];
  List<EventModel> _events = [];
  bool _loading = false;

  Map<int, Widget> _profileTabs = <int, Widget>{
    0: Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        'Posts',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    ),
    1: Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        'Media',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    ),
    2: Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        'Events',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    ),
  };

  Widget buildProfileWidgets(UserModel author) {
    switch (_profileSegmentedValue) {
      case 0:
        return
            // Container(child: Text('Post'));
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _allStatus.length,
                itemBuilder: (context, index) {
                  return StatusContainer(
                    userModel: widget.userModel,
                    author: author,
                    status: _allStatus[index],
                  );
                });

      case 1:
        return
            // Center(child: Text('Media'));
            Container(
          // margin:EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
          padding: EdgeInsets.only(top: 10.0),
          // color: Colors.amber,
          child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _mediaStatus.length,
              padding: EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.0,
              ),
              itemBuilder: (context, index) {
                return MediaContainer(
                  userModel: widget.userModel,
                  author: author,
                  status: _mediaStatus[index],
                );
              }),
        );
      case 2:
        return StreamBuilder<DocumentSnapshot>(
            stream: UserController().getUser(id: widget.userModel.uid),
            builder: (context, snapshot) {
              try {
                if (!snapshot.data!.exists) return const Text("Loading");
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                UserModel userModel = UserModel.fromDoc(doc: snapshot.data!);

                return SizedBox(
                  child: userModel.usertype == 'H I K E R'
                      ? SingleChildScrollView(
                          child: Column(
                            children: [
                              HikerUpcomingEvent(userModel: userModel),
                              HikerCompletedEvent(
                                userModel: userModel,
                              )
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            OperatorUpcomingEvent(
                              userModel: userModel,
                            ),
                            OperatorCompletedEvent(
                              userModel: userModel,
                            )
                          ],
                        ),
                );
              } catch (e) {
                return Text("Loading...");
              }
            });
      default:
        return Center(
            child: Text('Something wrong', style: TextStyle(fontSize: 25)));
    }
  }

  getFollowersCount() async {
    int followersCount =
        await DatabaseServices.followersNum(widget.userModel.uid);
    if (mounted) {
      setState(() {
        _followersCount = followersCount;
      });
    }
  }

  getFollowingCount() async {
    int followingCount =
        await DatabaseServices.followingNum(widget.userModel.uid);
    if (mounted) {
      setState(() {
        _followingCount = followingCount;
      });
    }
  }

  followOrUnFollow() {
    if (_isFollowing) {
      unFollowUser();
    } else {
      followUser();
    }
  }

  unFollowUser() {
    DatabaseServices.unFollowUser(
        FirebaseAuth.instance.currentUser!.uid, widget.userModel.uid);
    setState(() {
      _isFollowing = false;
      _followersCount--;
    });
  }

  followUser() {
    DatabaseServices.followUser(
        FirebaseAuth.instance.currentUser!.uid, widget.userModel.uid);
    setState(() {
      _isFollowing = true;
      _followersCount++;
    });
  }

  setupIsFollowing() async {
    bool isFollowingThisUser = await DatabaseServices.isFollowingUser(
        FirebaseAuth.instance.currentUser!.uid, widget.userModel.uid);
    setState(() {
      _isFollowing = isFollowingThisUser;
    });
  }

  getAllStatus() async {
    setState(() {
      _loading = true;
    });
    List<StatusModel>? userStatus =
        (await DatabaseServices.getUserStatus(widget.userModel.uid))
            .cast<StatusModel>();

    if (mounted) {
      setState(() {
        _allStatus = userStatus;
        _mediaStatus =
            _allStatus.where((element) => element.image.isNotEmpty).toList();
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getFollowersCount();
    getFollowingCount();
    setupIsFollowing();
    getAllStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            children: [
          Column(children: <Widget>[
            Column(children: [
              Container(
                child:
                    Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                  _loading ? LinearProgressIndicator() : SizedBox.shrink(),
                  Align(
                    alignment: Alignment.topRight,
                    child: FirebaseAuth.instance.currentUser!.uid ==
                            widget.userModel.uid
                        ? PopupMenuButton(
                            icon: Icon(
                              Icons.more_horiz,
                              color: Colors.black,
                              size: 30,
                            ),
                            itemBuilder: (_) {
                              return <PopupMenuItem<String>>[
                                new PopupMenuItem(
                                  child: Text('Logout'),
                                  value: 'logout',
                                )
                              ];
                            },
                            onSelected: (selectedItem) {
                              if (selectedItem == 'logout')
                                AuthService.logout();

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()),
                              );
                            })
                        : Column(
                            children: [
                              AppBar(
                                backgroundColor: Colors.white,
                                iconTheme: IconThemeData(color: Colors.black),
                                title: Image(
                                  image: AssetImage('assets/images/Logo2.png'),
                                  width: 100.0,
                                  height: 100.0,
                                ),
                                centerTitle: true,
                              ),
                              SizedBox(height: 40),
                            ],
                          ),
                  ),

                  Container(
                      transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                      child: CircleAvatar(
                        radius: 52,
                        backgroundImage: widget.userModel.profilePicture.isEmpty
                            ? AssetImage('assets/images/placeholder.png')
                            : NetworkImage(widget.userModel.profilePicture)
                                as ImageProvider,
                      )),
                  Container(
                      alignment: Alignment.center,
                      transform: Matrix4.translationValues(0.0, -25.0, 0.0),
                      width: 100,
                      height: 20,
                      padding: EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.green[400]),
                      child: Center(
                          child: Text(widget.userModel.usertype,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold)))),
                  Container(
                      transform: Matrix4.translationValues(0.0, -16.0, 0.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(widget.userModel.fname,
                                style: TextStyle(
                                    fontSize: 19, fontWeight: FontWeight.bold)),
                            SizedBox(width: 5),
                            Text(widget.userModel.lname,
                                style: TextStyle(
                                    fontSize: 19, fontWeight: FontWeight.bold))
                          ])),
                  Container(
                      transform: Matrix4.translationValues(0.0, -15.0, 0.0),
                      child: Text(widget.userModel.bio,
                          style: TextStyle(fontSize: 14))),
                  SizedBox(height: 5),
                  Container(
                    transform: Matrix4.translationValues(0.0, -8.0, 0.0),
                    width: 80,
                    height: 20,
                    child: FirebaseAuth.instance.currentUser!.uid ==
                            widget.userModel.uid
                        ? ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                _loading = true;
                              });
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EditProfile(user: widget.userModel)),
                              );
                              setState(() {
                                _loading = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Colors.grey,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0))),
                            child: Text('Edit',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 11)),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              followOrUnFollow();
                            },
                            style: ElevatedButton.styleFrom(
                                primary:
                                    _isFollowing ? Colors.white : Colors.grey,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0))),
                            child: Text(_isFollowing ? 'Following' : 'Follow',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 11)),
                          ),
                  ),
                  SizedBox(height: 5),
                  Container(
                      transform: Matrix4.translationValues(0.0, -8.0, 0.0),
                      width: 80,
                      height: 20,
                      child: FirebaseAuth.instance.currentUser!.uid ==
                              widget.userModel.uid
                          ? SizedBox(height: 1)
                          : ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.grey,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0))),
                              child: Text('Message',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 11)),
                            )),
                  // SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FollowersScreen(
                                        followersCount: _followersCount,
                                        followingCount: _followingCount,
                                        currentUserId: widget.userModel.uid,
                                        selectedTab: 1,
                                        updateFollowersCount: (count) {
                                          setState(
                                              () => _followersCount = count);
                                        },
                                        updateFollowingCount: (count) {
                                          setState(
                                              () => _followingCount = count);
                                        },
                                        user: widget.userModel,
                                        visitedUserId: widget.userModel.uid,
                                      )));
                        },
                        child: Text(
                          '$_followingCount Following',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FollowersScreen(
                                        followersCount: _followersCount,
                                        followingCount: _followingCount,
                                        currentUserId: widget.userModel.uid,
                                        selectedTab: 0,
                                        updateFollowersCount: (count) {
                                          setState(
                                              () => _followersCount = count);
                                        },
                                        updateFollowingCount: (count) {
                                          setState(
                                              () => _followingCount = count);
                                        },
                                        user: widget.userModel,
                                        visitedUserId: widget.userModel.uid,
                                      )));
                        },
                        child: Text(
                          '$_followersCount Followers',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
              )
            ]),
            SizedBox(height: 10),
            Container(
                //height:50,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      child: CupertinoSlidingSegmentedControl(
                        groupValue: _profileSegmentedValue,
                        thumbColor: Colors.orangeAccent,
                        backgroundColor: Colors.transparent,
                        children: _profileTabs,
                        onValueChanged: (i) {
                          setState(() {
                            _profileSegmentedValue = i as int;
                          });
                        },
                      )),
                )),
            // SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: Divider(),
            ),
            buildProfileWidgets(widget.userModel),
          ]),
        ]));
  }
}
