import 'package:flutter/material.dart';

import '../screens/add_question_screen.dart';
import 'show_alert_dialog_ques_type_list.dart';

void modalBottomSheetMenuForQuestionType({
  BuildContext context,
  List<String> title,
  Function reBuildWidget,
}) {
  List<IconData> icons = [
    Icons.account_circle_rounded,
    Icons.info,
    Icons.check_box_outlined,
    Icons.view_headline
  ];
  print(title);
  String typeTitle = "";
  Future<String> _futureTitle = showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10.0),
        topRight: Radius.circular(10.0),
      ),
    ),
    builder: (builder) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
        ),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: title.length,
          itemBuilder: (BuildContext context, int index) {
            print(index);
            return ListTile(
              leading: Icon(icons[index], color: Colors.grey.shade800),
              title: Text(title[index]),
              horizontalTitleGap: 10.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              onTap: () {
                reBuildWidget();
                typeTitle = title[index];
                Navigator.pop(context);
                if (typeTitle != '') {
                  if (typeTitle.toLowerCase().contains('user')) {
                    showAlertDialogForQuestionTypeList(userQuestions,
                        userQuestionsIcon, context, reBuildWidget);
                  } else if (typeTitle.toLowerCase().contains('data')) {
                    showAlertDialogForQuestionTypeList(dataEntryQuestions,
                        dataEntryQuestionsIcons, context, reBuildWidget);
                  } else if (typeTitle.toLowerCase().contains('selection')) {
                    showAlertDialogForQuestionTypeList(selectionQuestions,
                        selectionQuestionsIcons, context, reBuildWidget);
                  } else {
                    questionType = 'Header';
                    showSaveForNewQuestion = true;
                  }
                }
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              color: Colors.black87,
              indent: 10.0,
              endIndent: 10.0,
              // thickness: 1.0,
            );
          },
        ),
      );
    },
  );
  _futureTitle.then((String value) => _closeModal(typeTitle));
}

void _closeModal(String value) {
  print(value);
  typeTitleSelected = value;
}
