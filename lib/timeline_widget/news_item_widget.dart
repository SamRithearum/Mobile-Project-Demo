import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../create_post_widget/edit_post_widget.dart';
import '../values/colors.dart';

class NewsItemWidget extends StatefulWidget {
  const NewsItemWidget({Key key, this.docSnapshot}) : super(key: key);

  final DocumentSnapshot docSnapshot;

  @override
  _NewsItemWidgetState createState() => _NewsItemWidgetState();
}

class _NewsItemWidgetState extends State<NewsItemWidget> {
  final firebase = Firestore.instance;

  bool _isLoading = false;

  void deletePost() async {
    setState(() {
      _isLoading = true;
    });
    await firebase
        .collection('posts')
        .document(widget.docSnapshot.documentID)
        .delete()
        .whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      child: Container(
        constraints: BoxConstraints.expand(height: 419),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              left: 0,
              top: 30,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryBackground,
                ),
                child: Container(),
              ),
            ),
            Positioned(
              left: 0,
              top: 80,
              right: 0,
              bottom: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 200,
                    child: Image.network(
                      widget.docSnapshot['image'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 20, top: 18, right: 20, bottom: 22),
                      child: Text(
                        widget.docSnapshot['caption'],
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Color.fromARGB(255, 7, 7, 7),
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          height: 1.42857,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 59,
                    decoration: BoxDecoration(
                      color: AppColors.accentElement,
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditPostWidget(
                                  docSnapshot: widget.docSnapshot,
                                ),
                              ),
                            );
                          },
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 19,
                                height: 19,
                                margin: EdgeInsets.only(left: 20),
                                child: Icon(Icons.edit),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 5),
                                child: Opacity(
                                  opacity: 0.4,
                                  child: Text(
                                    'Edit',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: AppColors.primaryText,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: deletePost,
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 19,
                                height: 19,
                                margin: EdgeInsets.only(right: 5),
                                child: Icon(Icons.delete),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 20),
                                child: Opacity(
                                  opacity: 0.4,
                                  child: Text(
                                    'Delete',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: AppColors.primaryText,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 9,
              top: 14,
              right: 10,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 82,
                    height: 82,
                    child: Image.asset(
                      'assets/images/icon-avatar.png',
                      fit: BoxFit.none,
                    ),
                  ),
                  Container(
                    width: 128,
                    height: 64,
                    margin: EdgeInsets.only(left: 8, top: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            widget.docSnapshot['username']
                                .toString()
                                .toUpperCase(),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Color.fromARGB(255, 15, 15, 15),
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: EdgeInsets.only(top: 3),
                            child: Opacity(
                              opacity: 0.4,
                              child: Text(
                                timeago.format(
                                    widget.docSnapshot['updated_at'].toDate()),
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: AppColors.primaryText,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      inAsyncCall: _isLoading,
    );
  }
}
