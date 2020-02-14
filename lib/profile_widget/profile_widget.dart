import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../values/colors.dart';
import '../welcome_widget/welcome_widget.dart';

class ProfileWidget extends StatefulWidget {
  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  String email = 'email@gmail.com';
  String username = 'username';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getUserInfo().whenComplete(() {
      setState(() {});
    });
  }

  void signOut() {
    setState(() {
      _isLoading = true;
    });
    _auth.signOut().whenComplete(() async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.clear();
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => WelcomeWidget()),
          (Route<dynamic> route) => false);
    });
  }

  Future<void> getUserInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    email = preferences.getString('email');
    username = email.substring(0, email.indexOf('@'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Profile',
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
        child: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 244, 242, 244),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 256,
                margin: EdgeInsets.only(top: 112),
                decoration: BoxDecoration(
                  color: AppColors.primaryBackground,
                ),
                child: Column(
                  children: [
                    Container(
                      width: 124,
                      height: 124,
                      margin: EdgeInsets.only(top: 25),
                      child: Image.asset(
                        'assets/images/avatar-temp.png',
                        fit: BoxFit.none,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 11),
                      child: Text(
                        username.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromARGB(255, 5, 12, 22),
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w400,
                          fontSize: 26,
                          height: 1.23077,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Opacity(
                        opacity: 0.4,
                        child: Text(
                          email.toLowerCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromARGB(255, 5, 12, 22),
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
            ],
          ),
        ),
        inAsyncCall: _isLoading,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.red,
        onPressed: signOut,
        label: Text('LOG OUT'),
      ),
    );
  }
}
