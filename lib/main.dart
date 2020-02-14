import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'tab_bar_widget/tab_bar_widget.dart';
import 'welcome_widget/welcome_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isUid = false;

  @override
  void initState() {
    super.initState();
    checkToken().then((onValue) {
      _isUid = onValue;
      setState(() {});
    });
  }

  Future<bool> checkToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.containsKey('uid');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Demo',
      home: _isUid ? TabBarWidget() : WelcomeWidget(),
    );
  }
}
