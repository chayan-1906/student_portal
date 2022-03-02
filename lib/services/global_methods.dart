import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_portal/screens/home_screen.dart';

class GlobalMethods {
  static Future<void> customDialog(BuildContext context, String title,
      String subtitle, Function func) async {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 6.0),
                child: Image.asset(
                  'assets/images/warning.png',
                  height: 20.0,
                  width: 20.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: TextStyle(
                    letterSpacing: 1.1,
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.height * 0.03,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            subtitle,
            style: TextStyle(
              letterSpacing: 0.8,
              fontWeight: FontWeight.w500,
              fontSize: MediaQuery.of(context).size.height * 0.03,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: MediaQuery.of(context).size.height * 0.03,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                func();
              },
              child: Text(
                'Delete',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: MediaQuery.of(context).size.height * 0.03,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<void> authErrorDialog(
      BuildContext context, String title, String subtitle) async {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 6.0),
                child: Image.asset(
                  'assets/images/warning.png',
                  height: 20.0,
                  width: 20.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: TextStyle(
                    letterSpacing: 1.1,
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height * 0.03,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            subtitle,
            style: TextStyle(
              letterSpacing: 0.8,
              fontWeight: FontWeight.w500,
              fontSize: MediaQuery.of(context).size.height * 0.03,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Okay',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: MediaQuery.of(context).size.height * 0.03,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<void> signOutDialog(
      BuildContext context, String title, String subtitle) async {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 6.0),
                child: Image.network(
                  'https://image.flaticon.com/icons/png/128/1828/1828304.png',
                  height: 20.0,
                  width: 20.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: TextStyle(
                    letterSpacing: 1.1,
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.height * 0.03,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            subtitle,
            style: TextStyle(
              letterSpacing: 0.8,
              fontWeight: FontWeight.w700,
              fontSize: MediaQuery.of(context).size.height * 0.03,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
              child: Text(
                'No',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: MediaQuery.of(context).size.height * 0.03,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.canPop(context) ? Navigator.pop(context) : null;
                await FirebaseAuth.instance.signOut();
              },
              child: Text(
                'Yes',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: MediaQuery.of(context).size.height * 0.03,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<dynamic> buildDiscardWarningDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            title: Text(
              'Do you want to discard?',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: MediaQuery.of(context).size.height * 0.03,
              ),
            ),
            elevation: 8.0,
            actions: [
              /// yes button
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    PageTransition(
                      child: HomeScreen(),
                      type: PageTransitionType.rippleLeftDown,
                    ),
                  );
                },
                child: Text(
                  'Yes',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: MediaQuery.of(context).size.height * 0.03,
                  ),
                ),
              ),

              /// no button
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'No',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: MediaQuery.of(context).size.height * 0.03,
                  ),
                ),
              ),
            ],
          );
        });
  }
}
