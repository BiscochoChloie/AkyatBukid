import 'package:akyatbukid/Models/UserModel.dart';
import 'package:akyatbukid/Services/dataServices.dart';
import 'package:akyatbukid/screens/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class FollowersScreen extends StatefulWidget {
  final UserModel user;
  final int followersCount;
  final int followingCount;
  final int selectedTab; // 0 - Followers / 1 - Following

  final Function updateFollowersCount;
  final Function updateFollowingCount;
  final String currentUserId;
  final String visitedUserId;

  const FollowersScreen(
      {required this.user,
      required this.followersCount,
      required this.followingCount,
      required this.selectedTab,
      required this.updateFollowersCount,
      required this.updateFollowingCount,
      required this.currentUserId,
      required this.visitedUserId});

  @override
  _FollowersScreenState createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {
  List<UserModel> _userFollowers = [];
  List<UserModel> _userFollowing = [];
  bool _isLoading = false;
  List<bool> _userFollowersState = [];
  List<bool> _userFollowingState = [];
  int _followingCount = 0;
  int _followersCount = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      _followersCount = widget.followersCount;
      _followingCount = widget.followingCount;
    });
    _setupAll();
  }

  _setupAll() async {
    setState(() {
      _isLoading = true;
    });
    await _setupFollowers();
    await _setupFollowing();
    setState(() {
      _isLoading = false;
    });
  }

  Future _setupFollowers() async {
    List<String> userFollowersIds =
        await DatabaseServices.getUserFollowersIds(widget.user.uid);

    List<UserModel> userFollowers = [];
    List<bool> userFollowersState = [];
    for (String userId in userFollowersIds) {
      UserModel user = await DatabaseServices.getUserWithId(userId);
      userFollowersState.add(true);
      userFollowers.add(user);
    }

    setState(() {
      _userFollowersState = userFollowersState;
      _userFollowers = userFollowers;
      _followersCount = userFollowers.length;
      if (_followersCount != widget.followersCount) {
        widget.updateFollowersCount(_followersCount);
      }
    });
  }

  Future _setupFollowing() async {
    List<String> userFollowingIds =
        await DatabaseServices.getUserFollowingIds(widget.user.uid);

    List<UserModel> userFollowing = [];
    List<bool> userFollowingState = [];
    for (String userId in userFollowingIds) {
      UserModel user = await DatabaseServices.getUserWithId(userId);
      userFollowingState.add(true);
      userFollowing.add(user);
    }
    setState(() {
      _userFollowingState = userFollowingState;
      _userFollowing = userFollowing;
      _followingCount = userFollowing.length;
      if (_followingCount != widget.followingCount) {
        widget.updateFollowingCount(_followingCount);
      }
    });
  }

  _goToUserProfile(BuildContext context, UserModel user) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ProfilePage(
              userModel: user,
            )));
  }

  _buildFollower(UserModel user, int index) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25.0,
        backgroundColor: Colors.grey,
        backgroundImage: user.profilePicture.isEmpty
            ? AssetImage('assets/images/placeholder.png')
            : NetworkImage(user.profilePicture) as ImageProvider,
      ),
      title: Row(
        children: [
          Text(user.fname),
          // UserBadges(user: user, size: 15), 
        ],
      ),
      subtitle: Text(user.usertype,style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
      onTap: () => _goToUserProfile(context, user),
    );
  }

  _buildFollowing(UserModel user, int index) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25.0,
        backgroundColor: Colors.grey,
        backgroundImage: user.profilePicture.isEmpty
            ? AssetImage('assets/images/placeholder.png')
            : NetworkImage(user.profilePicture) as ImageProvider,
      ),
      title: Row(
        children: [
          Text(user.fname),
          // UserBadges(user: user, size: 15),
        ],
      ),
      subtitle: Text(user.usertype,style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
      onTap: () => _goToUserProfile(context, user),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: widget.selectedTab,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            title: Row(
              children: [
                Text(
                  widget.user.fname + ' ' + widget.user.lname,
                  style: TextStyle(color: Colors.black),
                ),
                // UserBadges(user: widget.user, size: 15),
              ],
            ),
            bottom: TabBar(
              labelColor: Colors.black,
              tabs: [
                Tab(
                  text:
                      '${NumberFormat.compact().format(_followersCount)} Followers',
                ),
                Tab(
                  text:
                      '${NumberFormat.compact().format(_followingCount)} Following',
                ),
              ],
            )),
        body: !_isLoading
            ? TabBarView(
                children: [
                  RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      await _setupFollowers();
                      setState(() {
                        _isLoading = false;
                      });
                    },
                    child: ListView.builder(
                      itemCount: _userFollowers.length,
                      itemBuilder: (BuildContext context, int index) {
                        UserModel follower = _userFollowers[index];
                        return _buildFollower(follower, index);
                      },
                    ),
                  ),
                  RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      await _setupFollowing();
                      setState(() {
                        _isLoading = false;
                      });
                    },
                    child: ListView.builder(
                      itemCount: _userFollowing.length,
                      itemBuilder: (BuildContext context, int index) {
                        UserModel follower = _userFollowing[index];
                        return _buildFollowing(follower, index);
                      },
                    ),
                  ),
                ],
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
