import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:nanoid/nanoid.dart';
import 'package:student_portal/screens/home_screen.dart';
import 'package:student_portal/services/constants.dart';
import 'package:student_portal/services/school_question_list.dart';

import '../models/class_model.dart';
import '../models/question_model.dart';
import '../screens/add_question_screen.dart';

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

  static String createUniqueID() {
    String generatedId = customAlphabet(
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789', 38);
    print(generatedId);
    return generatedId;
  }

  static Future<void> addNewClass({
    BuildContext context,
    String selectedClass,
    String selectedSec,
    CollectionReference classesReference,
  }) async {
    print('addNewClass called');
    String generatedId = GlobalMethods.createUniqueID();
    Timestamp _classCreationTime = Timestamp.now();
    print('$selectedClass ${selectedSec.split('Section - ')[1]}');
    await classesReference.doc(generatedId).set(ClassModel(
          id: generatedId,
          createdAt: _classCreationTime,
          class_name: selectedClass,
          section_name: selectedSec,
        ).toMap());
  }

  static Future<void> saveNewQuestion() async {
    String questionId = GlobalMethods.createUniqueID();
    List<String> validAnsList = [];
    if (validAnsController.text != '') {
      List<String> validAnswers = validAnsController.text.split('\n');
      print(validAnswers);
      for (String s in validAnswers) {
        print('s : $s');
        if (s.isNotEmpty && s != '' && s != null && s != ' ' && s != '\n') {
          validAnsList.add(s);
        }
      }
    }
    QuestionModel questionModel = QuestionModel(
      questionId: questionId,
      classImage: '',
      questionNumber: SchoolQuestionList.schoolQuestions.length,
      isOptional: !isRequiredQues,
      question: questionController.text,
      questionType: questionType,
      validAnswers: validAnsList,
    );
    // SchoolQuestionList.schoolQuestions = [];
    await Constants.questionsReference
        .doc(questionId)
        .set(questionModel.toJson())
        .then((value) {
      SchoolQuestionList.schoolQuestions.add(questionModel);
    });
  }

  static Future<void> updateListOrder({int oldIndex, int newIndex}) async {
    /// update the question index
    print('$oldIndex     $newIndex');
    String questionId;

    /// get the questionId of newIndex
    await Constants.questionsReference
        .where('questionNumber', isEqualTo: newIndex)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        questionId = doc.get('questionId');
      });
    }).then((value) async {
      /// update the questionNumber of oldIndex
      await Constants.questionsReference
          .where('questionNumber', isEqualTo: oldIndex)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.update({'questionNumber': newIndex});
        });
      });

      /// update the questionNumber of newIndex
      await Constants.questionsReference
          .where('questionId', isEqualTo: questionId)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.update({'questionNumber': oldIndex});
        });
      });
    });
  }

  static updateOldQuestion(
      String classId, String questionId, Function() refresh) async {}
}
