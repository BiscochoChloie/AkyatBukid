import 'package:flutter/material.dart';
  
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:akyatbukid/Models/UserModel.dart';
import 'package:akyatbukid/screens/profile.dart';
import 'package:akyatbukid/Services/dataServices.dart';



class BookingPage extends StatefulWidget {
  final String currentUserId;

  const BookingPage({Key key, this.currentUserId}) : super(key: key);
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  Future<QuerySnapshot> _users;
  TextEditingController _searchController = TextEditingController();

  clearSearch() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _searchController.clear());
    setState(() {
      _users = null;
    });
  }

  buildUserTile(UserModel user) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: user.profilePicture.isEmpty
            ? AssetImage('assets/placeholder.png')
            : NetworkImage(user.profilePicture),
      ),
      title: Text(user.fname +' ' + user.lname),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProfilePage (
                  currentUserId: widget.currentUserId,
                  visitedUserId: user.id,
                )));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.5,
        title: Container(
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 15),
              hintText: 'Search ...',
              hintStyle: TextStyle(color: Colors.white),
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: Colors.white),
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.clear,
                  color: Colors.white,
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
      body: Column(
        children: [
          Container(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                  hintText: 'Search ...',
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Colors.white,
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
     
    
        _users == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data.docs.length == 0) {
                  return Center(
                    child: Text('No users found!'),
                  );
                }
                return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      UserModel user =
                          UserModel.fromDoc(snapshot.data.docs[index]);
                      return buildUserTile(user);
                    });
              }),
     ],
      )  );
  }
}