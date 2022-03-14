import 'package:flutter/material.dart';
import 'package:student_portal/services/color_themes.dart';
import 'package:student_portal/services/school_question_list.dart';

import '../components/show_cancel_alert_dialog.dart';
import '../components/show_saving_dialog.dart';
import '../models/question_model.dart';
import '../services/global_methods.dart';
import '../widgets/modal_bottom_sheet_ques_type.dart';

List<String> noValidAns = [
  'Name',
  'Birthday',
  'Address',
  'Yes/No',
  'Short Text',
  'Number',
  'Date',
  'Switch',
  'Long Text',
  'Gender',
  'Email',
  'Phone',
  'Image',
  'File',
  'Header/Banner',
  'Alternate Phone',
  'Alternate Email',
  'Header',
];

List<IconData> userQuestionsIcon = [
  Icons.person,
  Icons.phone,
  Icons.email,
  Icons.home_rounded,
  Icons.people_rounded,
  Icons.cake
];

List<String> userQuestions = [
  'Name',
  'Phone',
  'Email',
  'Address',
  'Gender',
  'Birthday'
];

List<IconData> dataEntryQuestionsIcons = [
  Icons.short_text,
  Icons.notes,
  Icons.exposure_zero,
  Icons.calendar_today,
  Icons.email,
  Icons.phone,
  Icons.image,
];

List<String> dataEntryQuestions = [
  'Short Text',
  'Long Text',
  'Number',
  'Date',
  'Alternate Email',
  'Alternate Phone',
  'Image',
];

List<IconData> selectionQuestionsIcons = [
  Icons.check_circle_rounded,
  Icons.toggle_on_rounded,
  Icons.grid_view,
  Icons.radio_button_checked,
  Icons.check_box_outlined,
  Icons.arrow_drop_down,
  Icons.power_input_outlined,
];

List<String> selectionQuestions = [
  'Yes/No',
  'Switch',
  'Chip',
  'Select Single Box',
  'Select Multiple Box',
  'Drop Down',
  'Slider',
];

bool isRequiredQues = false;
String typeTitleSelected = '';
String questionType = '';
bool showSaveForNewQuestion = false;
TextEditingController questionController = TextEditingController();
TextEditingController validAnsController = TextEditingController();

class AddQuestionScreen extends StatefulWidget {
  final String className;
  final Function() refresh;
  final List schoolQuestions;
  final bool updateOld;
  final String classId;
  final String questionId;

  const AddQuestionScreen({
    Key key,
    this.className,
    this.refresh,
    this.schoolQuestions,
    this.updateOld,
    this.classId,
    this.questionId,
  }) : super(key: key);

  @override
  _AddQuestionScreenState createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {

  bool nameCheck = false;
  bool phoneCheck = false;
  bool emailCheck = false;
  bool dobCheck = false;
  bool genderCheck = false;
  bool addressCheck = false;

  reset() {
    questionController.text = '';
    validAnsController.text = '';
    questionType = '';
    isRequiredQues = false;
    showSaveForNewQuestion = false;
    nameCheck = false;
    phoneCheck = false;
    emailCheck = false;
    dobCheck = false;
    genderCheck = false;
    addressCheck = false;
  }

  reBuildWidget() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (widget.updateOld) {
      showSaveForNewQuestion = false;
    } else {
      reset();
    }
  }

  Future<dynamic> onBackPressed() async {
    if (showSaveForNewQuestion) {
      showDialog(
          context: context,
          builder: (BuildContext ctx) {
            return ShowCancelAlertBox(reset: reset);
          });
    } else {
      questionController.text = "";
      validAnsController.text = "";
      questionType = '';
      isRequiredQues = false;
      showSaveForNewQuestion = false;
      widget.refresh();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => onBackPressed(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Question', style: TextStyle()),
          leading: IconButton(
            onPressed: onBackPressed,
            icon: Icon(Icons.arrow_back_ios_rounded),
          ),
          centerTitle: true,
          elevation: 0.0,
          actions: [
            IconButton(
              onPressed: () async {
                if (questionController.text.isNotEmpty &&
                    questionType.isNotEmpty) {
                  if (!noValidAns.contains(questionType)) {
                    if (validAnsController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('Options required for this question type'),
                          duration: const Duration(milliseconds: 3000),
                          backgroundColor: ColorThemes.errorColor,
                        ),
                      );
                    } else if (questionType.toLowerCase().contains("slider")) {
                      List<String> val = validAnsController.text.split('\n');
                      if (val.length < 2) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Both Minimum and maximum value are required for slider'),
                          duration: const Duration(milliseconds: 3000),
                          backgroundColor: ColorThemes.errorColor,
                        ));
                      } else {
                        try {
                          double min = double.parse(val[0]);
                          double max = double.parse(val[1]);
                          if (min >= max) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Maximum value must be greater than minimum value'),
                                duration: const Duration(milliseconds: 3000),
                                backgroundColor: ColorThemes.errorColor,
                              ),
                            );
                          } else {
                            ShowSavingDialog(context: context, text: 'Saving');
                            if (widget.updateOld) {
                              await GlobalMethods.updateOldQuestion(
                                widget.classId,
                                widget.questionId,
                                widget.refresh,
                              );
                              Navigator.pop(context);
                              Navigator.pop(context);
                            } else {
                              await GlobalMethods.saveNewQuestion();
                              setState(() {
                                reset();
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      Icon(
                                        Icons.check_rounded,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.06),
                                      Text('Question saved successfully'),
                                    ],
                                  ),
                                  duration: Duration(seconds: 3),
                                  backgroundColor: ColorThemes.primaryColor,
                                ),
                              );
                              Navigator.pop(context);
                            }
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Only number type value allowed for slider'),
                              duration: const Duration(milliseconds: 3000),
                              backgroundColor: ColorThemes.errorColor,
                            ),
                          );
                        }
                      }
                    } else {
                      ShowSavingDialog(context: context, text: 'Saving');
                      if (widget.updateOld) {
                        await GlobalMethods.updateOldQuestion(
                            widget.classId, widget.questionId, widget.refresh);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      } else {
                        await GlobalMethods.saveNewQuestion();
                        setState(() {
                          reset();
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Row(
                            children: [
                              Icon(Icons.check_rounded, color: Colors.white),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.06),
                              Text('Question saved successfully'),
                            ],
                          ),
                          duration: Duration(seconds: 3),
                          backgroundColor: ColorThemes.primaryColor,
                        ));
                        Navigator.pop(context);
                      }
                    }
                  } else {
                    ShowSavingDialog(context: context, text: 'Saving');
                    if (widget.updateOld) {
                      await GlobalMethods.updateOldQuestion(
                          widget.classId, widget.questionId, widget.refresh);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    } else {
                      await GlobalMethods.saveNewQuestion();
                      setState(() {
                        reset();
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(Icons.check_rounded, color: Colors.white),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.06),
                              Text('Question saved successfully'),
                            ],
                          ),
                          duration: Duration(seconds: 3),
                          backgroundColor: ColorThemes.primaryColor,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Both name and question type are required'),
                      backgroundColor: ColorThemes.errorColor,
                      duration: const Duration(milliseconds: 3000),
                    ),
                  );
                }
              },
              icon: Icon(Icons.check_rounded),
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(10.0),
          child: ListView(
            children: [
              SizedBox(height: 10.0),

              /// question textformfield
              TextFormField(
                cursorColor: Colors.black87,
                controller: questionController,
                maxLines: 10,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Question Text',
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                style: const TextStyle(fontSize: 15.0),
                onChanged: (String val) {
                  setState(() {
                    showSaveForNewQuestion = true;
                  });
                },
              ),
              SizedBox(height: 20.0),

              /// question type selection dropdown
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          modalBottomSheetMenuForQuestionType(
                            context: context,
                            title: [
                              'User Profile Questions',
                              'Data Entry Questions',
                              'Selection Questions',
                              'Header',
                            ],
                            reBuildWidget: reBuildWidget,
                          );
                          print('title selected: $typeTitleSelected');
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 20.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(questionType == ''
                                ? 'Question Type'
                                : questionType),
                            Icon(Icons.arrow_drop_down_rounded),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20.0),

              /// required ques switch tile
              SwitchListTile(
                title: const Text('Required'),
                value: isRequiredQues,
                onChanged: (bool value) {
                  setState(() {
                    showSaveForNewQuestion = true;
                    isRequiredQues = value;
                  });
                },
                activeColor: ColorThemes.primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
