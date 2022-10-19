import 'package:akyatbukid/Models/UserModel.dart';
import 'package:akyatbukid/Models/chat.dart';
import 'package:akyatbukid/Models/room.dart';
import 'package:akyatbukid/constant/constant.dart';
import 'package:akyatbukid/controller/chat_controller.dart';
import 'package:akyatbukid/controller/room_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:uuid/uuid.dart';
import 'package:ntp/ntp.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:intl/intl.dart';

final _firestroe = FirebaseFirestore.instance;

class PrivateMessage extends StatefulWidget {
  static const String id = 'privatemessage';
  final UserModel userModel;
  final UserModel currentUserModel;
  final String ownerID;

  const PrivateMessage(
      {Key? key,
      required this.userModel,
      required this.currentUserModel,
      required this.ownerID})
      : super(key: key);
  @override
  _PrivateMessageState createState() => _PrivateMessageState();
}

class _PrivateMessageState extends State<PrivateMessage> {
  final messageTextController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool newCreate = true;
  late String ownerID;
  String? messageText;

  @override
  void initState() {
    ownerID = widget.ownerID;
    // print(widget.currentUserModel.uid);
    super.initState();
  }

  Widget build(BuildContext context) {
    bool isOwner = ownerID.isNotEmpty
        ? (widget.ownerID == widget.currentUserModel.uid)
        : true;
    TextEditingController message = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Image(
          image: AssetImage('assets/images/Logo2.png'),
          width: 100.0,
          height: 100.0,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        // bottom: PreferredSize(
        //   child: Row(
        //     children: [
        //       Padding(
        //         padding: const EdgeInsets.all(8.0),
        //         child: CircleAvatar(
        //           radius: 20,
        //           backgroundImage: widget.userModel.profilePicture.isEmpty
        //               ? AssetImage('assets/images/placeholder.png')
        //               : NetworkImage(widget.userModel.profilePicture)
        //                   as ImageProvider,
        //         ),
        //       ),
        //       Text(widget.userModel.fname + ' ' + widget.userModel.lname,
        //           style: TextStyle(color: Colors.black, fontSize: 17)),
        //     ],
        //   ),
        //   preferredSize: Size(50, 40),
        // ),
      ),
      // body: SingleChildScrollView(child: Column(children: [])),
      body: ownerID.isEmpty
          ? Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 86,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage: widget
                                  .userModel.profilePicture.isEmpty
                              ? AssetImage('assets/images/placeholder.png')
                              : NetworkImage(widget.userModel.profilePicture)
                                  as ImageProvider,
                        ),
                      ),
                      Text(
                          widget.userModel.fname + ' ' + widget.userModel.lname,
                          style: TextStyle(color: Colors.black, fontSize: 17)),
                    ],
                  ),
                  Expanded(
                      child: Center(
                    child: Text("No messages"),
                  )),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(children: [
                      Expanded(
                        child: TextField(
                          controller: message,
                          minLines: 1,
                          maxLines: 3,
                          decoration: InputDecoration(hintText: "Message..."),
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              if (newCreate &&
                                  message.text.isNotEmpty &&
                                  ownerID.isEmpty) {
                                newCreate = false;
                                var uuid = Uuid();
                                var uuidChat = Uuid();
                                String roomID = uuid.v1() +
                                    "-" +
                                    widget.userModel.uid +
                                    "-" +
                                    widget.currentUserModel.uid;
                                Room room = Room(
                                    guestID: widget.userModel.uid,
                                    ownerID: widget.currentUserModel.uid,
                                    id: roomID);
                                Chat chat = Chat(
                                    message: message.text,
                                    roomID: room.id,
                                    fromUserID: widget.currentUserModel.uid,
                                    toUserID: widget.userModel.uid,
                                    timestamp: Timestamp.now(),
                                    id: uuidChat.v1());
                                RoomController().upSert(room: room);
                                ChatController().upSert(room: chat);
                                ownerID = widget.currentUserModel.uid;
                              }
                            });
                            message.text = "";
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Icon(
                              Icons.send,
                              color: Colors.green[800],
                            ),
                          ))
                    ]),
                  ),
                ],
              ))
          : FutureBuilder<QuerySnapshot>(
              future: RoomController().getRoomWithOwnerGuestID(
                  owner: widget.ownerID,
                  guest: isOwner
                      ? widget.userModel.uid
                      : widget.currentUserModel.uid),
              builder: (context, snapshot) {
                late Room currentRoom;

                if (!snapshot.hasData) {
                  return Center();
                }
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                if (snapshot.data!.docs.isNotEmpty) {
                  currentRoom = Room.fromDoc(snapshot.data!.docs.first);
                }

                try {
                  return Container(
                      alignment: Alignment.bottomCenter,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 86,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundImage: widget
                                          .userModel.profilePicture.isEmpty
                                      ? AssetImage(
                                          'assets/images/placeholder.png')
                                      : NetworkImage(
                                              widget.userModel.profilePicture)
                                          as ImageProvider,
                                ),
                              ),
                              Text(
                                  widget.userModel.fname +
                                      ' ' +
                                      widget.userModel.lname,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 17)),
                            ],
                          ),
                          Expanded(
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: ChatController().getChatWithRoomID(
                                      roomID: currentRoom.id),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData)
                                      return Center(
                                        child: Text("No messages."),
                                      );
                                    if (snapshot.data!.docs.isNotEmpty) {
                                      List<Chat> chats =
                                          snapshot.data!.docs.map((e) {
                                        return Chat.fromDoc(e);
                                      }).toList();

                                      chats.sort((a, b) =>
                                          b.timestamp.compareTo(a.timestamp));
                                      return ListView(
                                        reverse: true,
                                        children: chats.map((chat) {
                                          bool isFromUser = chat.fromUserID ==
                                              widget.currentUserModel.uid;
                                          String date = DateFormat.yMMMMd(
                                                  'en_US')
                                              .add_jm()
                                              .format(DateTime
                                                  .fromMillisecondsSinceEpoch(chat
                                                      .timestamp
                                                      .millisecondsSinceEpoch));
                                          if (!isFromUser) {
                                            chat.seen = true;
                                            ChatController().upSert(room: chat);
                                          }
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment: isFromUser
                                                  ? CrossAxisAlignment.end
                                                  : CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  date,
                                                  style: TextStyle(fontSize: 8),
                                                ),
                                                BubbleSpecialOne(
                                                  text: chat.message,
                                                  isSender: isFromUser,
                                                  color: Colors.green,
                                                  textStyle: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white,
                                                    // fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      );
                                    }
                                    return Center();
                                  })),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Row(children: [
                              Expanded(
                                child: TextField(
                                  controller: message,
                                  minLines: 1,
                                  maxLines: 3,
                                  decoration:
                                      InputDecoration(hintText: "Message..."),
                                ),
                              ),
                              TextButton(
                                  onPressed: () async {
                                    if (snapshot.data!.docs.isEmpty &&
                                        message.text.isNotEmpty) {
                                      var uuid = Uuid();
                                      var uuidChat = Uuid();
                                      Room room = Room(
                                          guestID: widget.userModel.uid,
                                          ownerID: widget.currentUserModel.uid,
                                          id: uuid.v1());
                                      Chat chat = Chat(
                                          message: message.text,
                                          roomID: room.id,
                                          fromUserID:
                                              widget.currentUserModel.uid,
                                          toUserID: widget.userModel.uid,
                                          timestamp: Timestamp.fromDate(
                                              await NTP.now()),
                                          id: uuidChat.v1());
                                      RoomController().upSert(room: room);
                                      ChatController().upSert(room: chat);
                                    }
                                    if (currentRoom != null) {
                                      var uuidChat = Uuid();
                                      Chat chat = Chat(
                                          message: message.text,
                                          roomID: currentRoom.id,
                                          fromUserID:
                                              widget.currentUserModel.uid,
                                          toUserID: widget.userModel.uid,
                                          timestamp: Timestamp.now(),
                                          id: uuidChat.v1());
                                      ChatController().upSert(room: chat);
                                    }
                                    message.text = "";
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Icon(
                                      Icons.send,
                                      color: Colors.green,
                                    ),
                                  ))
                            ]),
                          ),
                        ],
                      ));
                } catch (e) {
                  return Center();
                }
              }),
      bottomNavigationBar: SingleChildScrollView(
        child: Container(),
      ),
    );
  }
}
