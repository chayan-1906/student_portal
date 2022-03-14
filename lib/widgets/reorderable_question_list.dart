import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:student_portal/components/loading_spinkit_wave.dart';
import 'package:student_portal/models/question_model.dart';
import 'package:student_portal/screens/add_question_screen.dart';

import '../services/color_themes.dart';
import '../services/global_methods.dart';
import '../services/school_question_list.dart';

String validText(List<dynamic> list) {
  String validText = '';
  for (var ans in list) {
    validText = validText + ans + '\n';
  }
  return validText;
}

class ReorderableQuestionList extends StatefulWidget {
  final String classId;
  final String className;
  final Function() refresh;
  // final List schoolQuestions;

  const ReorderableQuestionList({
    Key key,
    this.classId,
    this.className,
    this.refresh,
    // this.schoolQuestions,
  }) : super(key: key);

  @override
  _ReorderableQuestionListState createState() =>
      _ReorderableQuestionListState();
}

class _ReorderableQuestionListState extends State<ReorderableQuestionList> {
  // List schoolQuestions;
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // schoolQuestions = widget.schoolQuestions;
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? LoadingSpinkitWave(color: ColorThemes.primaryColor)
        : ReorderableListView(
            // shrinkWrap: true,
            children: SchoolQuestionList.schoolQuestions
                .map(
                  (questionItem) => ListTile(
                    onTap: () {
                      questionController.text = questionItem.question;
                      questionType = questionItem.questionType;
                      validAnsController.text =
                          validText(questionItem.validAnswers);
                      isRequiredQues = !questionItem.isOptional;
                      Navigator.push(
                        context,
                        PageTransition(
                          child: AddQuestionScreen(
                            className: widget.className,
                            refresh: widget.refresh,
                            schoolQuestions: SchoolQuestionList.schoolQuestions,
                            updateOld: true,
                            questionId: questionItem.questionId,
                            classId: widget.classId,
                          ),
                          type: PageTransitionType.rippleRightUp,
                        ),
                      );
                    },
                    key: Key(questionItem.questionId),
                    title: Text(
                      questionItem.question,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(questionItem.questionType),
                    leading: Icon(Icons.reorder_rounded,
                        color: ColorThemes.primaryColor),
                    // isThreeLine: true,
                    trailing: IconButton(
                      onPressed: () {
                        questionController.text = questionItem.question;
                        questionType = questionItem.questionType;
                        validAnsController.text =
                            validText(questionItem.validAnswers);
                        isRequiredQues = !questionItem.isOptional;
                        Navigator.push(
                          context,
                          PageTransition(
                            child: AddQuestionScreen(
                              className: widget.className,
                              refresh: widget.refresh,
                              schoolQuestions:
                                  SchoolQuestionList.schoolQuestions,
                              updateOld: true,
                              questionId: questionItem.questionId,
                              classId: widget.classId,
                            ),
                            type: PageTransitionType.rippleRightUp,
                          ),
                        );
                      },
                      icon: Icon(Icons.edit_rounded),
                    ),
                  ),
                )
                .toList(),
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }
                final questions =
                    SchoolQuestionList.schoolQuestions.removeAt(oldIndex);
                SchoolQuestionList.schoolQuestions.insert(newIndex, questions);
                setState(() {
                  loading = true;
                });
                GlobalMethods.updateListOrder(
                  oldIndex: oldIndex,
                  newIndex: newIndex,
                ).then((value) {
                  setState(() {
                    loading = false;
                  });
                });
              });
            },
          );
  }
}
