import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/color_themes.dart';

showDeletingDialog(context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Deleting'),
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
