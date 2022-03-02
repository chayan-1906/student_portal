import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_portal/screens/home_screen.dart';
import 'package:student_portal/services/color_themes.dart';

import '../components/loading_spinkit_wave.dart';
import '../screens/landing_screen.dart';

class UserState extends StatelessWidget {
  static const String routeName = '/user_state';

  const UserState({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, userSnapshot) {
        print('userSnapshot: $userSnapshot');
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: LoadingSpinkitWave(color: ColorThemes.primaryColor),
          );
        } else if (userSnapshot.connectionState == ConnectionState.active) {
          if (userSnapshot.hasData) {
            print('The user has already logged in ${userSnapshot.data}');
            return const HomeScreen();
          } else {
            print('The user didn\'t log in');
            return const LandingScreen();
          }
        } else if (userSnapshot.hasError) {
          return Center(
            child: Text(
              'Error occurred',
              style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrangeAccent,
              ),
            ),
          );
        } else {
          return Center(
            child: Text(
              'Error occurred',
              style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrangeAccent,
              ),
            ),
          );
        }
      },
    );
  }
}
