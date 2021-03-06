import 'package:flutter/material.dart';
import 'package:akyatbukid/constant/constant.dart';
import 'package:akyatbukid/Models/StatusModel.dart';
import 'package:akyatbukid/Models/UserModel.dart';
import 'package:akyatbukid/newsfeed/addStatus.dart';
import 'package:akyatbukid/Services/dataServices.dart';
import 'package:akyatbukid/newsfeed/statusContainer.dart';

class FeedPage extends StatefulWidget {
  final String currentUserId;

  const FeedPage({Key key, this.currentUserId}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  List _followingStatus = [];
  bool _loading = false;

  buildStatus(StatusModel status, UserModel author) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: StatusContainer(
        status: status,
        author: author,
        currentUserId: widget.currentUserId,
      ),
    );
  }

  showFollowingStatus(String currentUserId) {
    List<Widget> followingStatusList = [];
    for (StatusModel status in _followingStatus) {
      followingStatusList.add(FutureBuilder(
          future: usersRef.doc(status.authorId).get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              UserModel author = UserModel.fromDoc(snapshot.data);
              return buildStatus(status, author);
            } else {
              return SizedBox.shrink();
            }
          }));
    }
    return followingStatusList;
  }

  setupFollowingStatus() async {
    setState(() {
      _loading = true;
    });
    List followingStatus =
        await DatabaseServices.getHomeStatus(widget.currentUserId);
    if (mounted) {
      setState(() {
        _followingStatus = followingStatus;
        _loading = false;
      });
    }
  }

  void _incrementCounter() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AddStatus(currentUserId: widget.currentUserId)));
  }

  @override
  void initState() {
    super.initState();
    setupFollowingStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () => setupFollowingStatus(),
        child: ListView(
          physics: BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          children: [
            _loading ? LinearProgressIndicator() : SizedBox.shrink(),
            SizedBox(height: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 5),
                Column(
                  children: _followingStatus.isEmpty && _loading == false
                      ? [
                          // SizedBox(height: 5),
                          Center(
                            child: Text(
                              'There is No New Post',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          )
                        ]
                      : showFollowingStatus(widget.currentUserId),
                ),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[800],
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.create),
      ),
    );
  }
}
