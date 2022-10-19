import 'package:akyatbukid/Models/StatusModel.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:akyatbukid/Models/UserModel.dart';
import 'package:akyatbukid/Services/dataServices.dart';

class StatusContainer extends StatefulWidget {
  final StatusModel status;
  final UserModel author;
  final UserModel userModel;

  const StatusContainer({
    Key? key,
    required this.status,
    required this.author,
    required this.userModel,
  }) : super(key: key);
  @override
  _StatusContainerState createState() => _StatusContainerState();
}

class _StatusContainerState extends State<StatusContainer> {
  int _likesCount = 0;
  bool _isLiked = false;

  initStatusLikes() async {
    bool isLiked = await DatabaseServices.isLikeStatus(
        widget.userModel.uid, widget.status);
    if (mounted) {
      setState(() {
        _isLiked = isLiked;
      });
    }
  }

  likeStatus() {
    if (_isLiked) {
      DatabaseServices.unlikeStatus(widget.userModel.uid, widget.status);
      setState(() {
        _isLiked = false;
        _likesCount -= 1;
      });
    } else {
      DatabaseServices.likeStatus(widget.userModel.uid, widget.status);
      setState(() {
        _isLiked = true;
        _likesCount += 1;
      });
    }
  }

//     Future deletePost(int index) async {
//     var dialogResponse = await _dialogService.showConfirmationDialog(
//       title: 'Are you sure?',
//       description: 'Do you really want to delete the post?',
//       confirmationTitle: 'Yes',
//       cancelTitle: 'No',
//     );

//     if (dialogResponse.confirmed) {
//       setBusy(true);
//       await _firestoreService.deletePost(_posts[index].documentId);
//       setBusy(false);
//     }
//   }
// }

  @override
  void initState() {
    super.initState();
    _likesCount = widget.status.likes;
    initStatusLikes();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
      child: Card(
        elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.status.image.isEmpty
                  ? SizedBox.shrink()
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Container(
                            height: 250,
                            decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(widget.status.image),
                                )),
                          ),
                        )
                      ],
                    ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: widget.author.profilePicture.isEmpty
                          ? AssetImage('assets/images/placeholder.png')
                          : NetworkImage(widget.author.profilePicture)
                              as ImageProvider,
                    ),
                  ),
                  Text(
                    widget.author.fname + " " + widget.author.lname,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: widget.userModel.uid ==
                                FirebaseAuth.instance.currentUser!.uid &&
                            widget.status.authorId ==
                                FirebaseAuth.instance.currentUser!.uid
                        ? PopupMenuButton(
                            icon: Icon(
                              Icons.more_horiz,
                              color: Colors.black,
                              size: 30,
                            ),
                            itemBuilder: (_) {
                              return <PopupMenuItem<String>>[
                                new PopupMenuItem(
                                  child: Text('Delete'),
                                  value: 'delete',
                                ),
                              ];
                            },
                            onSelected: (selectedItem) {
                              if (selectedItem == 'delete') {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.QUESTION,
                                  buttonsBorderRadius:
                                      BorderRadius.all(Radius.circular(2)),
                                  headerAnimationLoop: false,
                                  animType: AnimType.BOTTOMSLIDE,
                                  title: 'Delete Post?',
                                  // desc: 'Dialog description here...',

                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () async {
                                    // Navigator.pop(context);
                                    await DatabaseServices.deleteStatus(
                                        widget.status);
                                    setState(() {});
                                  },
                                ).show();
                              }
                            })
                        : SizedBox(height: 5),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 5.0, 4.0, 10.0),
                child: Text(
                  widget.status.text,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              Divider(height: 2, color: Colors.black),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          _isLiked
                              ? Icons.thumb_up_alt_rounded
                              : Icons.thumb_up_alt_outlined,
                          color: _isLiked ? Colors.blue : Colors.black,
                        ),
                        onPressed: likeStatus,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          _likesCount.toString(),
                        ),
                      ),
                    ],
                  ),
                  // Row(
                  //   children: <Widget> [
                  //     Icon(Icons.share_rounded, size: 20),
                  //     Padding(
                  //       padding: const EdgeInsets.only(left: 8.0),
                  //     )
                  //   ],
                  // ),
                  // Text(
                  //   widget.status.timestamp.toDate().toString().substring(0, 19),
                  //   style: TextStyle(color: Colors.grey),
                  // ),
                  Row(
                    children: [
                      Icon(Icons.location_on_rounded,
                          size: 20, color: Colors.grey),
                      Text(
                        widget.status.bukid,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
