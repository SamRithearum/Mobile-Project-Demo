import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../tab_bar_widget/tab_bar_widget.dart';
import '../values/colors.dart';
import '../values/radii.dart';
import '../values/shadows.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void onGroupPressed(BuildContext context) => Navigator.pop(context);

  void signIn(String email, String password) async {
    setState(() {
      _isLoading = true;
    });
    await _auth
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((onValue) async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('uid', onValue.user.uid);
      preferences.setString('email', onValue.user.email);
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => TabBarWidget()),
          (Route<dynamic> route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => this.onGroupPressed(context),
          icon: Image.asset(
            'assets/images/group-2.png',
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ModalProgressHUD(
        child: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.31089, 1.09827),
              end: Alignment(0.68911, -0.09827),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(top: 114),
                  child: Text(
                    'Log in',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.accentText,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      fontSize: 42,
                      letterSpacing: -1,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text(
                    'Welcome back.\nThe galaxy awaits you.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.accentText,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              Container(
                height: 101,
                margin: EdgeInsets.only(left: 20, top: 70, right: 20),
                decoration: BoxDecoration(
                  color: AppColors.primaryBackground,
                  boxShadow: [
                    Shadows.primaryShadow,
                  ],
                  borderRadius: Radii.k2pxRadius,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 20,
                      margin: EdgeInsets.only(left: 15, top: 14, right: 15),
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          contentPadding: EdgeInsets.all(0),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        ),
                        maxLines: 1,
                        autocorrect: false,
                      ),
                    ),
                    Opacity(
                      opacity: 0.1,
                      child: Container(
                        height: 1,
                        margin: EdgeInsets.only(top: 16),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryElement,
                        ),
                        child: Container(),
                      ),
                    ),
                    Container(
                      height: 20,
                      margin: EdgeInsets.only(left: 15, top: 14, right: 15),
                      child: TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          contentPadding: EdgeInsets.all(0),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        ),
                        obscureText: true,
                        maxLines: 1,
                        autocorrect: false,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(
                flex: 5,
              ),
              Container(
                height: 60,
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 11),
                child: FlatButton(
                  onPressed: () {
                    signIn(emailController.text, passwordController.text);
                  },
                  color: Color.fromARGB(255, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                  textColor: Color.fromARGB(255, 217, 104, 111),
                  padding: EdgeInsets.all(0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/icon-log-in.png',
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'LOG IN',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromARGB(255, 217, 104, 111),
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
        inAsyncCall: _isLoading,
      ),
    );
  }
}
