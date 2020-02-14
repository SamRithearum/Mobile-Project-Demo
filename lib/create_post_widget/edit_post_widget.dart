import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../tab_bar_widget/tab_bar_widget.dart';

class EditPostWidget extends StatefulWidget {
  const EditPostWidget({Key key, this.docSnapshot}) : super(key: key);

  final DocumentSnapshot docSnapshot;

  @override
  _EditPostWidgetState createState() => _EditPostWidgetState();
}

class _EditPostWidgetState extends State<EditPostWidget> {
  final captionController = TextEditingController();
  final firebase = Firestore.instance;

  bool _isLoading = false;

  Future<void> editPost() async {
    setState(() {
      _isLoading = true;
    });

    await firebase
        .collection('posts')
        .document(widget.docSnapshot.documentID)
        .updateData({
      'caption': captionController.text,
      'updated_at': Timestamp.now(),
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
          'Edit Old Post',
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
        child: Padding(
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
        inAsyncCall: _isLoading,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        onPressed: editPost,
        label: Text('DONE'),
      ),
    );
  }
}
