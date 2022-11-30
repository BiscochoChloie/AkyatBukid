import 'package:akyatbukid/newsfeed/search.dart';
import 'package:flutter/material.dart';
import 'package:akyatbukid/constant/constant.dart';
import 'package:akyatbukid/Models/StatusModel.dart';
import 'package:akyatbukid/Models/UserModel.dart';
import 'package:akyatbukid/newsfeed/addStatus.dart';
import 'package:akyatbukid/services/dataServices.dart';
import 'package:akyatbukid/newsfeed/statusContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedPage extends StatefulWidget {
  final UserModel userModel;

  const FeedPage({Key? key, required this.userModel}) : super(key: key);

  @override
  FeedPageState createState() => FeedPageState();
}

class FeedPageState extends State<FeedPage> {
  final List<StatusModel> _followingStatus = [];
  final bool _loading = false;

  Future<QuerySnapshot>? _users;
  final TextEditingController _searchController = TextEditingController();

  clearSearch() {
    _searchController.clear();
  }

  buildStatus(StatusModel status, UserModel author) {
    return Container(
      child: StatusContainer(
        status: status,
        author: author,
        userModel: widget.userModel,
      ),
    );
  }

  showFollowingStatus() {
    List<Widget> followingStatusList = [];
    for (StatusModel status in _followingStatus) {
      followingStatusList.add(FutureBuilder(
          future: usersRef.doc(status.authorId).get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              UserModel author = UserModel.fromDoc(doc: snapshot.data);
              return buildStatus(status, author);
            } else {
              return const SizedBox.shrink();
            }
          }));
    }
    return followingStatusList;
  }

  getFollowingStatus() async {
    List<String> userFollowingIds =
        await DatabaseServices.getUserFollowingIds(widget.userModel.uid);
    QuerySnapshot snapshot = await statusRef
        .doc(widget.userModel.uid)
        .collection('userStatus')
        .orderBy('timestamp', descending: true)
        .get();
    List<StatusModel> followingStatus =
        snapshot.docs.map((doc) => StatusModel.fromDoc(doc)).toList();

    setState(() {
      // ignore: avoid_function_literals_in_foreach_calls
      followingStatus.forEach((element) {
        if (_followingStatus.where((st) => st.id == element.id).isEmpty) {
          print(element.authorId);
          _followingStatus.add(element);
        }
      });
    });
    // ignore: avoid_function_literals_in_foreach_calls
    userFollowingIds.forEach((id) async {
      QuerySnapshot snapshot = await statusRef
          .doc(id)
          .collection('userStatus')
          .orderBy('timestamp', descending: true)
          .get();
      List<StatusModel> followingStatus =
          snapshot.docs.map((doc) => StatusModel.fromDoc(doc)).toList();
      setState(() {
        for (var element in followingStatus) {
          if (_followingStatus.where((st) => st.id == element.id).isEmpty) {
            _followingStatus.add(element);
          }
        }
      });
    });
  }

  void _incrementCounter() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddStatus(userModel: widget.userModel)));
  }

  @override
  void initState() {
    super.initState();
    getFollowingStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () => getFollowingStatus(),
        child: ListView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          children: [
            _loading
                ? const LinearProgressIndicator()
                : const SizedBox.shrink(),
            Container(
              padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 20.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  hintText: 'Search',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                  prefixIcon: const Icon(Icons.search, color: Colors.black),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear, color: Colors.grey[400]),
                    onPressed: () {},
                  ),
                  filled: true,
                ),
                readOnly: true,
                enableInteractiveSelection: false,
                // focusNode: FocusNode(),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchPage(
                                userModel: widget.userModel,
                              )));
                },
              ),
            ),
            const SizedBox(height: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 5),
                Column(
                  children: _followingStatus.isEmpty && _loading == false
                      ? [
                          // SizedBox(height: 5),
                          const Center(
                            child: Text(
                              'There is No New Post',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          )
                        ]
                      : showFollowingStatus(),
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
        child: const Icon(Icons.create),
      ),
    );
  }
}
