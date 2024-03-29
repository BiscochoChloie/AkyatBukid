import 'dart:io';
import 'package:akyatbukid/Models/StatusModel.dart';
import 'package:akyatbukid/Models/UserModel.dart';
import 'package:akyatbukid/services/dataServices.dart';
import 'package:akyatbukid/services/storageServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class AddStatus extends StatefulWidget {
  final UserModel userModel;

  const AddStatus({Key? key, required this.userModel}) : super(key: key);
  @override
  AddStatusState createState() => AddStatusState();
}

class AddStatusState extends State<AddStatus> {
  // TextEditingController writingTextController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  FocusNode writingTextFocus = FocusNode();
  bool _isLoading = false;
  var selectedItem;
  var setDefaultItem = true, setDefaultItemModel = true;
  //File _postImageFile;

  String? _statusText;
  File? _pickedImage;
  ImagePicker picker = ImagePicker();

  handleImageFromGallery() async {
    try {
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _pickedImage = File(image.path);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
        keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
        keyboardBarColor: Colors.white,
        nextFocus: true,
        actions: [
          KeyboardActionsItem(
            displayArrows: false,
            focusNode: _nodeText1,
          ),
          KeyboardActionsItem(focusNode: writingTextFocus, toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () {
                  handleImageFromGallery();
                  print('Select Image');
                  //_getImageandCrop();
                },
                child: Container(
                    color: Colors.grey,
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: const <Widget>[
                        Icon(Icons.add_photo_alternate_rounded, size: 28),
                        Text(
                          "Add Image",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    )),
              );
            }
          ])
        ]);
  }

  final int _value = 1;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Stack(children: <Widget>[
          KeyboardActions(
            config: _buildConfig(context),
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 14.0, left: 10.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.all(15.0),
                          ),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: 40,
                                    height: 40,
                                    child:
                                        Image.asset('assets/images/Logo2.png'),
                                  )),
                              Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(5)),
                                  width: 270,
                                  height: 100,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0, right: 10.0),
                                          child: TextFormField(
                                            autofocus: true,
                                            focusNode: writingTextFocus,
                                            decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                hintText:
                                                    'Input your status here',
                                                hintMaxLines: 4),
                                            onChanged: (value) {
                                              _statusText = value;
                                            },
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLines: null,
                                          ),
                                        ),
                                      ])),
                            ],
                          ),

                          // _postImageFile != null ? Image.file(_postImageFile,fit: Box.fill);

                          Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(55, 15, 12, 14),
                              child: Container(
                                  padding: const EdgeInsets.all(1.0),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Container(
                                      // padding: EdgeInsets.symmetric(
                                      //     horizontal: 10.0),
                                      // decoration: BoxDecoration(
                                      //   color: Colors.white,
                                      //   border: Border.all(
                                      //     color: Colors.grey,
                                      //     width: 0.3,
                                      //   ),
                                      //   borderRadius: BorderRadius.all(
                                      //     Radius.circular(
                                      //       30.0,
                                      //     ),
                                      //   ),
                                      // ),
                                      child: Column(children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            const SizedBox(width: 20.0),
                                            StreamBuilder<QuerySnapshot>(
                                              stream: FirebaseFirestore.instance
                                                  .collection('bukid')
                                                  .snapshots(),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<QuerySnapshot>
                                                      snapshot) {
                                                if (!snapshot.hasData) {
                                                  return Container();
                                                }
                                                return DropdownButton(
                                                  underline: Container(),
                                                  isExpanded: false,
                                                  value: selectedItem,
                                                  items: snapshot.data!.docs
                                                      .map((value) {
                                                    return DropdownMenuItem(
                                                      value: value.get('name'),
                                                      child: Text(
                                                          '${value.get('name')}'),
                                                    );
                                                  }).toList(),
                                                  onChanged: (value) {
                                                    debugPrint(
                                                        'selected onchange: $value');
                                                    setState(
                                                      () {
                                                        debugPrint(
                                                            'make selected: $value');

                                                        selectedItem = value;

                                                        setDefaultItem = false;

                                                        setDefaultItemModel =
                                                            true;
                                                      },
                                                    );
                                                  },
                                                  hint: const Text(
                                                    'Choose a mountain',
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            153,
                                                            153,
                                                            153,
                                                            1.0)),
                                                  ),
                                                );
                                              },
                                            ),
                                          ]),
                                    ),
                                  ]))))
                        ]),
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: _pickedImage == null
                      ? const SizedBox.shrink()
                      : Container(
                          height: 300,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(_pickedImage!),
                              )),
                        ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    if (_statusText != null && _statusText!.isNotEmpty) {
                      String image;
                      if (_pickedImage == null) {
                        image = '';
                      } else {
                        image = await StorageService.uploadStatusPicture(
                            _pickedImage!);
                      }
                      StatusModel status = StatusModel(
                        text: _statusText!,
                        image: image,
                        authorId: widget.userModel.uid,
                        bukid: selectedItem,
                        likes: 0,
                        comments: 0,
                        timestamp: Timestamp.fromDate(
                          DateTime.now(),
                        ),
                        id: '',
                      );
                      DatabaseServices.createStatus(status);
                      Navigator.pop(context);
                    }
                    setState(() {
                      _isLoading = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[800],
                      onPrimary: Colors.white,
                      padding: const EdgeInsets.fromLTRB(40, 8, 40, 8),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      textStyle: const TextStyle(
                        fontSize: 16,
                      )),
                  child: Text('Post'),
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : const SizedBox.shrink()
              ],
            ),
          ),
        ]));
  }

  // Future<void> _getImageAndCrop() async {
  //   File imageFileFromGallery = await ImagePicker.pickImage(source: ImageSource.gallery);
  //   if (imageFileFromGallery != null) {
  //     File cropImageFile = await Utils.cropImageFile(imageFileFromGallery);
  //     if (cropImageFile != null) {
  //       setState(() {
  //         _postImageFile = cropImageFile;
  //       });
  //     }
  //   }
  // }
}
