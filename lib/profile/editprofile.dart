import 'dart:io';

import 'package:akyatbukid/Models/UserModel.dart';
import 'package:akyatbukid/services/dataServices.dart';
import 'package:akyatbukid/services/storageServices.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  final UserModel user;

  const EditProfile({Key? key, required this.user}) : super(key: key);
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String? _fname;
  String? _lname;
  String? _bio;
  File? _profileImage;
  ImagePicker picker = ImagePicker();
  String? _imagePickedType;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  displayProfilePage() {
    if (_profileImage == null) {
      if (widget.user.profilePicture.isEmpty) {
        return const AssetImage('assets/images/placeholder.png');
      } else {
        return NetworkImage(widget.user.profilePicture);
      }
    } else {
      return FileImage(_profileImage!);
    }
  }

  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("From where do you want to take the photo? "),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    ListTile(
                        leading: const Icon(Icons.photo_library),
                        title: const Text('Gallery'),
                        onTap: () {
                          handleImageFromGallery();
                          Navigator.of(context).pop();
                        }),
                    ListTile(
                      leading: const Icon(Icons.photo_camera),
                      title: const Text('Camera'),
                      onTap: () {
                        handleImageFromCamera();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ));
        });
  }

//  handleImageFromGallery() async {
//     try {
//       XFile? image = await picker.pickImage(source: ImageSource.gallery);
//       if (image != null) {
//         setState(() {
//           _pickedImage = File(image.path);
//         });
//       }
//       return _pickedImage;
//     } catch (e) {
//       print(e);
//     }
//   }

  handleImageFromGallery() async {
    try {
      XFile? imageFile =
          await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (imageFile != null) {
        if (_imagePickedType == 'profile') {
          setState(() {
            _profileImage = File(imageFile.path);
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  handleImageFromCamera() async {
    try {
      XFile? imageFile =
          await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
      if (imageFile != null) {
        if (_imagePickedType == 'profile') {
          setState(() {
            _profileImage = File(imageFile.path);
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  saveProfile() async {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate() && !_isLoading) {
      setState(() {
        _isLoading = true;
      });
      String profilePictureUrl = '';
      // String coverPictureUrl = '';
      if (_profileImage == null) {
        profilePictureUrl = widget.user.profilePicture;
      } else {
        profilePictureUrl = await StorageService.uploadProfilePicture(
            widget.user.profilePicture, _profileImage!);
      }
      // if (_coverImage == null) {
      //   coverPictureUrl = widget.user.coverImage;
      // } else {
      //   coverPictureUrl = await StorageService.uploadCoverPicture(
      //       widget.user.coverImage, _coverImage);
      // }
      UserModel user = UserModel(
        uid: widget.user.uid,
        fname: _fname!,
        lname: _lname!,
        profilePicture: profilePictureUrl,
        bio: _bio!, address: '', birthday: '', contact: '', email: '',
        operatorId: '',
        usertype: '',
        // coverImage: coverPictureUrl,
      );

      DatabaseServices.updateUserData(user);
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    _fname = widget.user.fname;
    _lname = widget.user.lname;
    _bio = widget.user.bio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Image(
            image: AssetImage('assets/images/Logo2.png'),
            width: 100.0,
            height: 100.0,
          ),
          centerTitle: true,
        ),
        body: ListView(children: [
          Column(children: <Widget>[
            GestureDetector(
                onTap: () {
                  _imagePickedType = 'profile';
                  _showSelectionDialog(context);
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Stack(
                      children: [
                        CircleAvatar(
                            radius: 52, backgroundImage: displayProfilePage()),
                        CircleAvatar(
                          radius: 52,
                          backgroundColor: Colors.black54,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.camera_alt,
                                size: 25,
                                color: Colors.white,
                              ),
                              Text(
                                'Change Profile Photo',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ))),
            Form(
                key: _formKey,
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.fromLTRB(5, 0, 0, 3),
                            child: const Text(
                              'First Name',
                              style:
                                  TextStyle(fontSize: 13, color: Colors.black),
                            ),
                          ),
                          TextFormField(
                            initialValue: _fname,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none),
                              filled: true,
                              fillColor: const Color(0xFFe7edeb),
                              hintText: "First Name",
                            ),
                            validator: (input) => input!.trim().length < 2
                                ? 'please enter valid name'
                                : null,
                            onSaved: (value) {
                              _fname = value!;
                            },
                          ),
                          const SizedBox(height: 20),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.fromLTRB(5, 0, 0, 3),
                            child: const Text(
                              'Last Name',
                              style:
                                  TextStyle(fontSize: 13, color: Colors.black),
                            ),
                          ),
                          TextFormField(
                            initialValue: _lname,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none),
                              filled: true,
                              fillColor: const Color(0xFFe7edeb),
                              hintText: "Last Name",
                            ),
                            onSaved: (value) {
                              _lname = value!;
                            },
                          ),
                          const SizedBox(height: 20),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.fromLTRB(5, 0, 0, 3),
                            child: const Text(
                              'Bio',
                              style:
                                  TextStyle(fontSize: 13, color: Colors.black),
                            ),
                          ),
                          TextFormField(
                            initialValue: _bio,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none),
                              filled: true,
                              fillColor: const Color(0xFFe7edeb),
                              hintText: "Bio",
                            ),
                            onSaved: (value) {
                              _bio = value!;
                            },
                          ),
                        ]))),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: saveProfile,
              child: ElevatedButton(
                onPressed: () {
                  saveProfile();
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => NavPage()));
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
                child: Text('Save'),
              ),
            ),
            const SizedBox(height: 30),
            _isLoading
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.black),
                  )
                : const SizedBox.shrink()
          ])
        ]));
  }
}
