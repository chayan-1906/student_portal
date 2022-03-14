import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/add_question_screen.dart';
import '../services/color_themes.dart';

void showAlertDialogForQuestionTypeList(List<dynamic> qTypeList,
    List<dynamic> qTypeListIcon, BuildContext context, Function() reBuild) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          elevation: 8.0,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Close',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: ColorThemes.primaryColor,
                ),
              ),
            ),
          ],
          content: Container(
            height: MediaQuery.of(context).size.height * 0.50,
            width: MediaQuery.of(context).size.width * 0.60,
            child: ListView.separated(
              itemCount: qTypeList.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                    leading: Icon(
                      qTypeListIcon[index],
                      color: ColorThemes.primaryColor,
                    ),
                    title: Text(qTypeList[index]),
                    tileColor: Colors.grey.shade200,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    onTap: () {
                      reBuild();
                      showSaveForNewQuestion = true;
                      questionType = qTypeList[index];
                      Navigator.pop(context);
                    });
              },
              separatorBuilder: (BuildContext context, int index) {
                return Container(
                  height: 5.0,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                );
              },
            ),
          ),
        );
      });
}
