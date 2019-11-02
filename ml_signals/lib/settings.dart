import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  TextEditingController _controllerName = TextEditingController();
  File _image;
  String userId;
  bool _uploading = false;
  String _urlImage;

  Future _getImage(String source) async {
    File imageSelected;
    switch (source) {
      case "camera":
        imageSelected = await ImagePicker.pickImage(source: ImageSource.camera);
        break;
      case "gallery":
        imageSelected =
            await ImagePicker.pickImage(source: ImageSource.gallery);
        break;
    }

    setState(() {
      _image = imageSelected;
      if (_image != null) {
        _uploading = true;
        _uploadImage();
      }
    });
  }

  Future _uploadImage() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference rootFolder = storage.ref();
    StorageReference fileName =
        rootFolder.child("profile").child(userId + ".jpg");

    StorageUploadTask task = fileName.putFile(_image);

    task.events.listen((StorageTaskEvent storageEvent) {
      if (storageEvent.type == StorageTaskEventType.progress) {
        setState(() {
          _uploading = true;
        });
      } else if (storageEvent.type == StorageTaskEventType.success) {
        setState(() {
          _uploading = false;
        });
      }
    });

    task.onComplete.then((StorageTaskSnapshot snapshot) {
      _getImageURL(snapshot);
    });
  }

  Future _getImageURL(StorageTaskSnapshot snapshot) async {
    String url = await snapshot.ref.getDownloadURL();
    _updateImageURL(url);

    setState(() {
      _urlImage = url;
    });
  }

  _updateNameFirestore() {
    String name = _controllerName.text;
    Firestore db = Firestore.instance;

    Map<String, dynamic> userData = {"name": name};

    db.collection("users").document(userId).updateData(userData);
  }

  _updateImageURL(String url) {
    Firestore db = Firestore.instance;

    Map<String, dynamic> userData = {"urlImage": url};

    db.collection("users").document(userId).updateData(userData);
  }

  _getUserData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser currentUser = await auth.currentUser();
    userId = currentUser.uid;

    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot =
        await db.collection("users").document(userId).get();

    Map<String, dynamic> userData = snapshot.data;
    _controllerName.text = userData["name"];

    if (userData["urlImage"] != null) {
      _urlImage = userData["urlImage"];
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[600],
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(16),
                  child: _uploading ? CircularProgressIndicator() : Container(),
                ),
                CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.grey,
                    backgroundImage:
                        _urlImage != null ? NetworkImage(_urlImage) : null),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      child: Text("Camera",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                      onPressed: () {
                        _getImage("camera");
                      },
                    ),
                    FlatButton(
                      child: Text("Gallery",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                      onPressed: () {
                        _getImage("gallery");
                      },
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerName,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(24, 12, 24, 12),
                        hintText: "Name",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                      child: Text(
                        "Salve",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      color: Theme.of(context).primaryColor,
                      padding: EdgeInsets.fromLTRB(24, 12, 24, 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                      onPressed: () {
                        _updateNameFirestore();
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
