import 'package:akyatbukid/controller/user_controller.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:akyatbukid/Models/UserModel.dart';
import 'package:akyatbukid/screens/profile.dart';
import 'package:akyatbukid/services/dataServices.dart';

class SearchPage extends StatefulWidget {
  final UserModel userModel;

  const SearchPage({Key? key, required this.userModel}) : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Future<QuerySnapshot>? _users;
  final TextEditingController _searchController = TextEditingController();

  // clearSearch() {
  //   _searchController.clear();
  // }

  clearSearch() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _searchController.clear());
    setState(() {
      _users = null;
    });
  }

  buildUserTile(UserModel user) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            radius: 20,
            backgroundImage: user.profilePicture.isEmpty
                ? const AssetImage('assets/images/placeholder.png')
                : NetworkImage(user.profilePicture) as ImageProvider,
          ),
          title: Text('${user.fname} ${user.lname}',
              style: const TextStyle(
                  // fontWeight: FontWeight.bold
                  )),
          subtitle: Text(user.usertype,
              style:
                  const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProfilePage(
                      userModel: user,
                    )));
          },
        ),
        const Divider(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.5,
        title: const Image(
          image: AssetImage('assets/images/Logo2.png'),
          width: 100.0,
          height: 100.0,
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size(50, 80),
          child: Container(
            padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 15.0),
            child: TextField(
              textCapitalization: TextCapitalization.none,
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
          ),
        ),
      ),
      body: _users == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search,
                    size: 200,
                    color: Colors.grey[350],
                  ),
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
