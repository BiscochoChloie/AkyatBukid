import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:akyatbukid/Models/UserModel.dart';
import 'package:akyatbukid/screens/profile.dart';
import 'package:akyatbukid/services/dataServices.dart';

class MessagePage extends StatefulWidget {
  final UserModel userModel;

  const MessagePage({Key? key, required this.userModel}) : super(key: key);
  @override
  MessagePageState createState() => MessagePageState();
}

class MessagePageState extends State<MessagePage> {
  late Future<QuerySnapshot> _users;
  final TextEditingController _searchController = TextEditingController();

  clearSearch() {
    _searchController.clear();
  }

  // clearSearch() {
  //   WidgetsBinding.instance!
  //       .addPostFrameCallback((_) => _searchController.clear());
  //   setState(() {
  //     _users = null;
  //   });
  // }

  buildUserTile(UserModel user) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: user.profilePicture.isEmpty
            ? const AssetImage('assets/images/placeholder.png')
            : NetworkImage(user.profilePicture) as ImageProvider,
      ),
      title: Text('${user.fname} ${user.lname}'),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Chat(
                  userModel: widget.userModel,
                  //visitedUserId: user.uid,
                )));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        // centerTitle: true,
        elevation: 0.5,
        // but
        title: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
                hintText: 'Search ...',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none),
                prefixIcon: const Icon(Icons.search, color: Colors.black),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.grey[400],
                  ),
                  onPressed: () {
                    clearSearch();
                  },
                ),
                filled: true,
              ),
              autofocus: true,
              onChanged: (input) {
                if (input.isNotEmpty) {
                  setState(() {
                    _users = DatabaseServices.searchUsers(input);
                  });
                }
              },
            ),
          ],
        ),
      ),
      body: _users == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  //chatlists
                  Icon(Icons.search, size: 200),
                  Text(
                    'Search .uuu..',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
                  )
                ],
              ),
            )
          : FutureBuilder(
              future: _users,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data.docs.length == 0) {
                  return const Center(
                    child: Text('No users found!'),
                  );
                }
                return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      UserModel user =
                          UserModel.fromDoc(doc: snapshot.data.docs[index]);
                      UserModel.fromDoc(doc: snapshot.data.docs[index]);
                      return buildUserTile(user);
                    });
              }),
    );
  }
}

class Chat extends StatefulWidget {
  final UserModel userModel;

  const Chat({Key? key, required this.userModel}) : super(key: key);
  @override
  ChatState createState() => ChatState();
}

class ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 27),
              color: Colors.green,
              height: 70.0,
              //child: Text(user.fname + ' ' + user.lname),
            )
          ],
        ),
      ),
    );
  }
}
