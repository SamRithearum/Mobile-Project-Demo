import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../tab_bar_widget/tab_bar_widget.dart';

class CreatePostWidget extends StatefulWidget {
  @override
  _CreatePostWidgetState createState() => _CreatePostWidgetState();
}

class _CreatePostWidgetState extends State<CreatePostWidget> {
  final captionController = TextEditingController();
  final firebase = Firestore.instance;
  File image;

  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://mobiledemo-3f698.appspot.com');

  StorageUploadTask _uploadTask;
  String email = 'email@gmail.com';
  String username = 'username';

  bool _isLoading = false;

  void createPost() async {
    setState(() {
      _isLoading = true;
    });

    SharedPreferences preferences = await SharedPreferences.getInstance();
    email = preferences.getString('email');
    username = email.substring(0, email.indexOf('@'));

    _uploadTask = _storage
        .ref()
        .child(DateTime.now().millisecondsSinceEpoch.toString())
        .putFile(image);

    var downUrl = await (await _uploadTask.onComplete).ref.getDownloadURL();

    await firebase.collection('posts').add({
      'username': username,
      'caption': captionController.text,
      'updated_at': Timestamp.now(),
      'image': downUrl.toString(),
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TabBarWidget(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create New Post',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontFamily: 'Lato',
            fontWeight: FontWeight.w400,
            fontSize: 17,
          ),
        ),
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-0.01413, 0.51498),
              end: Alignment(1.01413, 0.48502),
              stops: [
                0,
                1,
              ],
              colors: [
                Color.fromARGB(255, 248, 132, 98),
                Color.fromARGB(255, 140, 28, 140),
              ],
            ),
          ),
        ),
      ),
      body: ModalProgressHUD(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Container(
                height: 32,
                margin: EdgeInsets.only(left: 15, top: 14, right: 18),
                child: TextField(
                  controller: captionController,
                  decoration: InputDecoration(
                    hintText: 'Caption',
                    contentPadding: EdgeInsets.all(0),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                  maxLines: 3,
                  autocorrect: false,
                ),
              ),
            ),
            SizedBox(
              height: 32.0,
            ),
            image == null
                ? IconButton(
                    iconSize: 128,
                    icon: Icon(Icons.photo),
                    onPressed: () async {
                      image = await ImagePicker.pickImage(
                              source: ImageSource.gallery)
                          .whenComplete(() {
                        setState(() {});
                      });
                    },
                  )
                : Container(
                    height: 200,
                    child: Image.file(
                      image,
                      fit: BoxFit.cover,
                    ),
                  ),
          ],
        ),
        inAsyncCall: _isLoading,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        onPressed: createPost,
        label: Text('POST'),
      ),
    );
  }
}
