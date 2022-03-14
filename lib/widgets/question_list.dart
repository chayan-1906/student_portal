import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_portal/components/loading_spinkit_wave.dart';
import 'package:student_portal/models/question_model.dart';
import 'package:student_portal/services/constants.dart';
import 'package:student_portal/services/school_question_list.dart';
import 'package:student_portal/services/color_themes.dart';

import '../screens/add_question_screen.dart';
import 'reorderable_question_list.dart';

class QuestionWidget extends StatelessWidget {
  final String className;
  final String classId;
  final Function() refresh;

  const QuestionWidget({
    Key key,
    @required this.className,
    @required this.classId,
    @required this.refresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return StreamBuilder(
        stream: Constants.questionsReference
            .orderBy('questionNumber', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none &&
              !snapshot.hasData) {
            print('null');
            return Container();
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            print('loading');
            return Center(
                child: LoadingSpinkitWave(color: ColorThemes.primaryColor));
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Container();
          }
          SchoolQuestionList.schoolQuestions =
              snapshot.data.docs.map((question) {
            return QuestionModel.fromDocument(question);
          }).toList();
          if (SchoolQuestionList.schoolQuestions.isEmpty) {
            return Center(
                child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// There are no questions for this class
                  Text(
                    'There are no questions for this class',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: width * 0.05,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  /// add a new question
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => AddQuestionScreen(
                            className: className,
                            classId: classId,
                            refresh: refresh,
                            schoolQuestions: SchoolQuestionList.schoolQuestions,
                            updateOld: false,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Add a new question',
                      style: TextStyle(
                          fontSize: width * 0.065,
                          fontWeight: FontWeight.w600,
                          color: ColorThemes.primaryColor),
                    ),
                  ),
                ],
              ),
            ));
          } else {
            return ReorderableQuestionList(
              classId: classId,
              className: className,
              refresh: refresh,
              // schoolQuestions: SchoolQuestionList.schoolQuestions,
            );
          }
        });
  }
}
