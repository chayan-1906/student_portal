import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_portal/services/color_themes.dart';

import '../models/school_model.dart';
import 'home_screen_shimmer.dart';

class SchoolDetails extends StatefulWidget {
  // static String routeName = '/userdetails';
  final double width;
  final double height;
  // final SchoolModel schoolModel;

  const SchoolDetails({
    Key key,
    this.width,
    this.height,
    // this.schoolModel
  }) : super(key: key);

  @override
  State<SchoolDetails> createState() => _SchoolDetailsState();
}

class _SchoolDetailsState extends State<SchoolDetails> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  SchoolModel schoolModel;

  String getInitialLetter() {
    String initialLetter = '';
    if (schoolModel.school_name.isNotEmpty) {
      initialLetter = schoolModel.school_name.substring(0, 1);
    }
    return initialLetter;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firebaseFirestore.collection('schools').snapshots(),
        builder: (context, snapshot) {
          print(snapshot.connectionState);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Stack(
              children: [
                Container(
                  width: widget.width * 0.94,
                  height: widget.height * 0.38 - widget.width * 0.05,
                ),

                /// shimmers
                Positioned(
                  top: widget.height * 0.02,
                  left: widget.width * 0.03,
                  right: widget.width * 0.03,
                  child: HomeScreenShimmer(
                    width: widget.width,
                    height: widget.height,
                  ),
                ),
              ],
            );
          }
          final schoolStream = snapshot.data.docs.map((school) {
            return SchoolModel.fromDocument(school);
          }).where((userItem) {
            return (userItem.id == _firebaseAuth.currentUser.uid);
          }).toList();
          schoolModel = schoolStream[0];
          return Container(
            height: widget.height * 0.38,
            width: widget.width * 0.94,
            // color: ColorThemes.userDetailsColor,
            child: Card(
              elevation: 8.0,
              color: ColorThemes.userDetailsColor.withOpacity(0.4),
              margin: EdgeInsets.symmetric(vertical: widget.height * 0.02),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(widget.height * 0.05)),
              shadowColor: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(widget.width * 0.05),
                    width: widget.width * 0.35,
                    child: schoolModel.email.isNotEmpty
                        ? CircleAvatar(
                            radius: widget.height * 0.10,
                            backgroundColor: ColorThemes.primaryColor,
                            child: Text(
                              getInitialLetter(),
                              style: GoogleFonts.arimo(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.1,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Image(
                            image:
                                AssetImage('assets/images/profile_picture.png'),
                            height: widget.height * 0.40,
                            width: widget.height * 0.40,
                          ),
                  ),
                  SizedBox(width: widget.width * 0.005),
                  Container(
                    width: widget.width * 0.55,
                    // color: Colors.lightBlueAccent,
                    padding: EdgeInsets.only(right: widget.width * 0.005),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /// username
                        AutoSizeText(
                          schoolModel.school_name,
                          maxLines: 1,
                          style:
                              GoogleFonts.arimo(fontSize: widget.height * 0.05),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),

                        /// email
                        AutoSizeText(
                          schoolModel.email,
                          maxLines: 1,
                          style:
                              GoogleFonts.arimo(fontSize: widget.height * 0.03),
                        ),

                        /// created at
                        /*AutoSizeText(
                          'Created At: ${schoolModel.createdAt.substring(0, 10)}',
                          maxLines: 1,
                          style:
                              GoogleFonts.arimo(fontSize: widget.height * 0.03),
                        ),*/

                        /// no of docs
                        AutoSizeText(
                          'Students ${schoolModel.studentsCount}',
                          maxLines: 1,
                          style:
                              GoogleFonts.arimo(fontSize: widget.height * 0.03),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
