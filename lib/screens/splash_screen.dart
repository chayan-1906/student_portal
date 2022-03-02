import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:student_portal/services/user_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void navigateToUserState() {
    Navigator.pushReplacement(
      context,
      PageTransition(
        child: UserState(),
        type: PageTransitionType.rippleRightUp,
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 4), navigateToUserState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text('Splash Screen'),
        ),
      ),
    );
  }
}
