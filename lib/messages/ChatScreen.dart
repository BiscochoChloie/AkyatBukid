import 'package:akyatbukid/Models/UserModel.dart';
import 'package:akyatbukid/Models/chat.dart';
import 'package:akyatbukid/Models/room.dart';
import 'package:akyatbukid/controller/chat_controller.dart';
import 'package:akyatbukid/controller/room_controller.dart';
import 'package:akyatbukid/controller/user_controller.dart';
import 'package:akyatbukid/messages/msearch.dart';
import 'package:akyatbukid/messages/privatemessage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../services/authServices.dart';

class ChatScreen extends StatefulWidget {
  final UserModel userModel;
  const ChatScreen({Key? key, required this.userModel}) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Room> rooms = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text('Messages',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              letterSpacing: 1.5,
            )),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            color: Colors.black,
            iconSize: 30.0,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MSearch(
                            currentUser: widget.userModel,
                          )));
            },
          )
        ],
      ),
      body: Container(
          padding: const EdgeInsets.only(top: 48.0),
          decoration: BoxDecoration(color: Color(0xffefeff1)),
          child: SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot>(
            stream: RoomController().rooms.snapshots(),
            builder: (context, snapshot) {
              List<Room> rooms = [];
              if (!snapshot.hasData)
                return Center(
                  child: Text("No inbox."),
                );
              snapshot.data!.docs.forEach((element) {
                Room room = Room.fromDoc(element);
                if (room.guestID == widget.userModel.uid ||
                    room.ownerID == widget.userModel.uid) {
                  if (rooms
                      .where((thisRoom) => thisRoom.id == room.id)
                      .isEmpty) {
                    rooms.add(room);
                  }
                }
              });
              try {
                return rooms.first.ownerID.isNotEmpty
                    ? Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height - 86,
                        child: ListView(
                          children: rooms.map((room) {
                            bool isOwner = room.ownerID == widget.userModel.uid;
                            return StreamBuilder<DocumentSnapshot>(
                              stream: UserController().getUser(
                                  id: isOwner ? room.guestID : room.ownerID),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) return Center();
                                UserModel user =
                                    UserModel.fromDoc(doc: snapshot.data!);
                                return StreamBuilder<QuerySnapshot>(
                                    stream: ChatController()
                                        .getChatWithRoomID(roomID: room.id),
                                    builder: (context, snapshot) {
                                      int unRead = 0;
                                      if (!snapshot.hasData) return Text("0");
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting)
                                        return Center(
                                            child: CircularProgressIndicator());

                                      snapshot.data!.docs.forEach((element) {
                                        Chat chat = Chat.fromDoc(element);
                                        bool isFromUser = chat.fromUserID ==
                                            widget.userModel.uid;
                                        if (!isFromUser && !chat.seen)
                                          unRead += 1;
                                      });
                                      Chat chat = Chat.fromDoc(
                                          snapshot.data!.docs.last);
                                      return TextButton(
                                          style: ButtonStyle(
                                              alignment: Alignment.centerLeft,
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      unRead > 0
                                                          ? Colors.white
                                                          : Colors
                                                              .transparent)),
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PrivateMessage(
                                                          ownerID: room.ownerID,
                                                          userModel: user,
                                                          currentUserModel:
                                                              widget.userModel,
                                                        )));
                                          },
                                          child: Card(
                                              elevation: 8,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Opacity(
                                                          opacity: 0.7,
                                                          child: Row(
                                                            children: [
                                                              CircleAvatar(
                                                                radius: 20,
                                                                backgroundImage: user
                                                                        .profilePicture
                                                                        .isEmpty
                                                                    ? AssetImage(
                                                                        'assets/images/placeholder.png')
                                                                    : NetworkImage(
                                                                            user.profilePicture)
                                                                        as ImageProvider,
                                                              ),
                                                              SizedBox(
                                                                  width: 8),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    user.fname +
                                                                        " " +
                                                                        user.lname,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .black87),
                                                                  ),
                                                                  Text(
                                                                    user.email,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            8,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 50,
                                                            ),
                                                            SizedBox(
                                                                width: 250,
                                                                child: Text(
                                                                  chat.message,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black87),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                )),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Text(unRead > 0
                                                        ? unRead.toString()
                                                        : "")
                                                  ],
                                                ),
                                              )));
                                    });
                              },
                            );
                          }).toList(),
                        ),
                      )
                    : Center(
                        child: Text("No messages"),
                      );
              } catch (e) {
                return Center();
              }
            },
          ))),
    );
  }
}
