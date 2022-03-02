import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_portal/models/school_model.dart';

import '../components/loading_spinkit_wave.dart';
import '../services/color_themes.dart';
import '../widgets/user_details.dart';
import 'package:shimmer/shimmer.dart';

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
                              .copyWith(fontSize: 30.0),
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
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
              child: TextButton.icon(
                onPressed: () {
                  // TODO" Navigate to Settings Screen
                },
                icon: Icon(Icons.settings_rounded, color: Colors.black),
                label: Text(
                  'Settings',
                  style: TextStyle(fontSize: width * 0.05, color: Colors.black),
                ),
              ),
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      body: _isLoading
          ? LoadingSpinkitWave(color: ColorThemes.primaryColor)
          : Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: _firebaseFirestore.collection('schools').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Stack(
                        children: [
                          Container(),

                          /// shimmers
                          // Positioned(
                          //   top: height * 0.02,
                          //   left: width * 0.03,
                          //   right: width * 0.03,
                          //   child: Shimmers(width: width, height: height),
                          // ),
                        ],
                      );
                    }
                    final schoolStream = snapshot.data.docs.map((school) {
                      return SchoolModel.fromDocument(school);
                    }).where((userItem) {
                      return (userItem.id == _firebaseAuth.currentUser.uid);
                    }).toList();
                    schoolModel = schoolStream[0];
                    return SchoolDetails(
                      width: width,
                      height: height,
                      schoolModel: schoolModel,
                    );
                  },
                ),
                Center(
                  child: Text('Home Screen'),
                ),
              ],
            ),
    );
  }
}
