import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:student_portal/screens/add_question_screen.dart';
import 'package:student_portal/services/constants.dart';
import 'package:student_portal/services/school_question_list.dart';
import 'package:student_portal/services/color_themes.dart';

import '../widgets/question_list.dart';

class QuestionListEditScreen extends StatefulWidget {
  final Function() refreshParentWidgetWhilePop;
  final String id;
  final String title;

  const QuestionListEditScreen({
    Key key,
    @required this.refreshParentWidgetWhilePop,
    @required this.id,
    @required this.title,
  }) : super(key: key);

  @override
  _QuestionListEditScreenState createState() => _QuestionListEditScreenState();
}

class _QuestionListEditScreenState extends State<QuestionListEditScreen> {
  // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  // CollectionReference _questionsReference;

  refresh() {
    setState(() {
      // _questionsReference.snapshots();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _questionsReference = _firebaseFirestore
    //     .collection('schools')
    //     .doc(_firebaseAuth.currentUser.uid)
    //     .collection('classes')
    //     .doc(widget.id)
    //     .collection('questions');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_rounded),
        ),
        title: Text('Add or Edit Questions', style: TextStyle()),
      ),
      body: QuestionWidget(
        className: widget.title,
        classId: widget.id,
        refresh: refresh,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            PageTransition(
              child: AddQuestionScreen(
                className: widget.title,
                classId: widget.id,
                refresh: refresh,
                schoolQuestions: SchoolQuestionList.schoolQuestions,
                updateOld: false,
              ),
              type: PageTransitionType.rippleRightUp,
            ),
          );
        },
        elevation: 0.0,
        child: Icon(Icons.add_rounded),
        backgroundColor: ColorThemes.primaryColor,
      ),
    );
  }
}
