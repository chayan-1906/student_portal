import 'package:flutter/material.dart';

import '../services/color_themes.dart';

ShowSavingDialog({@required BuildContext context, @required String text}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(text),
              SizedBox(height: 8.0),
              Container(
                height: 30.0,
                width: 30.0,
                child: CircularProgressIndicator(
                  color: ColorThemes.primaryColor,
                ),
              ),
            ],
          ),
        );
      });
}
