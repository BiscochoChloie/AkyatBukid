import 'package:akyatbukid/Models/UserModel.dart';
import 'package:akyatbukid/messages/ChatScreen.dart';
import 'package:akyatbukid/newsfeed/feed.dart';
import 'package:flutter/material.dart';
import 'package:akyatbukid/screens/booking.dart';
import 'screens/notification.dart';
import 'package:akyatbukid/screens/profile.dart';

class NavPage extends StatefulWidget {
  final UserModel userModel;

  const NavPage({Key? key, required this.userModel}) : super(key: key);

  @override
  NavPageState createState() => NavPageState();
}

class NavPageState extends State<NavPage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = [
      FeedPage(
        userModel: widget.userModel,
      ),
      BookingPage(
        userModel: widget.userModel,
      ),
      ChatScreen(userModel: widget.userModel),
      NotifScreen(),
      ProfilePage(
        userModel: widget.userModel,
      ),
    ];

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          title: Image(
            image: AssetImage('assets/images/Logo2.png'),
            width: 100.0,
            height: 100.0,
          ),
          centerTitle: true,
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          currentIndex: selectedIndex,
          onTap: (index) => setState(() {
            selectedIndex = index;
          }),
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.hiking), label: 'Book'),
            BottomNavigationBarItem(
                icon: Icon(Icons.message), label: 'Message'),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications), label: 'Notification'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
        body: Container(
          child: tabs[selectedIndex],
        ));
  }
}
