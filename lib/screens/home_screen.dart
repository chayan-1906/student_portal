import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:student_portal/models/school_model.dart';
import 'package:student_portal/screens/add_class_screen.dart';
import 'package:student_portal/screens/view_classes_screen.dart';

import '../components/loading_spinkit_wave.dart';
import '../services/color_themes.dart';
import '../widgets/user_details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  SchoolModel schoolModel;

  Future<void> _signOut() async {
    setState(() {
      _isLoading = true;
    });
    await _firebaseAuth.signOut();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight * 1.5),
        child: Container(
          decoration: BoxDecoration(
            color: ColorThemes.primaryColor,
            borderRadius:
                BorderRadius.vertical(bottom: Radius.elliptical(150, 30)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(top: kToolbarHeight * 0.2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            _scaffoldKey.currentState.openDrawer();
                          },
                          icon: Icon(Icons.menu_rounded),
                        ),
                        SizedBox(width: width * 0.10),
                        Text(
                          'Student Portal',
                          style: Theme.of(context)
                              .appBarTheme
                              .titleTextStyle
                              .copyWith(fontSize: width * 0.08),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        _signOut();
                      },
                      icon: Icon(Icons.logout_rounded),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: ColorThemes.primaryColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.school, size: width * 0.25),
                  Text(
                    'Student Portal',
                    style: TextStyle(fontSize: width * 0.07),
                  ),
                ],
              ),
            ),

            /// settings
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
              child: TextButton.icon(
                onPressed: () {
                  // TODO" Navigate to Settings Screen
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Settings')));
                },
                icon: Icon(Icons.settings_rounded, color: Colors.black),
                label: Text(
                  'Settings',
                  style: TextStyle(fontSize: width * 0.05, color: Colors.black),
                ),
              ),
            ),

            /// help
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
              child: TextButton.icon(
                onPressed: () {
                  // TODO" Navigate to Help Screen
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Help')));
                },
                icon: Icon(Icons.help, color: Colors.black),
                label: Text(
                  'Help',
                  style: TextStyle(fontSize: width * 0.05, color: Colors.black),
                ),
              ),
            ),

            /// about
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
              child: TextButton.icon(
                onPressed: () {
                  // TODO" Navigate to About Us Screen
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('About Us')));
                },
                icon: Icon(Icons.info_rounded, color: Colors.black),
                label: Text(
                  'About',
                  style: TextStyle(fontSize: width * 0.05, color: Colors.black),
                ),
              ),
            ),
            Divider(color: Colors.grey.shade400, thickness: 1.0),

            /// rate us
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
              child: TextButton.icon(
                onPressed: () {
                  // TODO" Navigate to Rate Us Screen
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Rate Us')));
                },
                icon: Icon(Icons.star_rate_rounded, color: Colors.black),
                label: Text(
                  'Rate Us',
                  style: TextStyle(fontSize: width * 0.05, color: Colors.black),
                ),
              ),
            ),

            /// contact us
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
              child: TextButton.icon(
                onPressed: () {
                  // TODO" Navigate to Contact Us Screen
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Contact Us')));
                },
                icon: Icon(Icons.email_rounded, color: Colors.black),
                label: Text(
                  'Contact Us',
                  style: TextStyle(fontSize: width * 0.05, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? LoadingSpinkitWave(color: ColorThemes.primaryColor)
          : Column(
              children: [
                SchoolDetails(
                  width: width,
                  height: height,
                  // schoolModel: schoolModel,
                ),

                /// add new class
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            child: AddClassScreen(),
                            type: PageTransitionType.rippleRightUp,
                          ),
                        );
                      },
                      child: Card(
                        elevation: 8.0,
                        margin: EdgeInsets.symmetric(
                          vertical: height * 0.02,
                          horizontal: width * 0.025,
                        ),
                        color: ColorThemes.secondaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(height * 0.05)),
                        child: Container(
                          padding: EdgeInsets.all(width * 0.07),
                          width: width * 0.94,
                          height: height * 0.17,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_box_rounded, size: width * 0.10),
                              SizedBox(width: width * 0.04),
                              Text(
                                'Add new Class',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: width * 0.08,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                /// all classes
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            child: ViewClassesScreen(),
                            type: PageTransitionType.rippleRightUp,
                          ),
                        );
                      },
                      child: Card(
                        elevation: 8.0,
                        margin: EdgeInsets.symmetric(
                          vertical: height * 0.02,
                          horizontal: width * 0.025,
                        ),
                        color: ColorThemes.secondaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(height * 0.05)),
                        child: Container(
                          padding: EdgeInsets.all(width * 0.07),
                          width: width * 0.94,
                          height: height * 0.16,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                MaterialCommunityIcons.eye,
                                size: width * 0.10,
                              ),
                              SizedBox(width: width * 0.04),
                              Text(
                                'All Classes',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: width * 0.08,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
