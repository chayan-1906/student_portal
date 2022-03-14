import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_portal/services/color_themes.dart';

class ShowDeleteAlertDialog extends StatefulWidget {
  final Function() delete;
  final String className;

  const ShowDeleteAlertDialog({
    Key key,
    this.delete,
    this.className,
  }) : super(key: key);

  @override
  _ShowDeleteAlertDialogState createState() => _ShowDeleteAlertDialogState();
}

class _ShowDeleteAlertDialogState extends State<ShowDeleteAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        padding: EdgeInsets.only(top: 10.0, left: 8.0, right: 8.0),
        child: Text(
          'Delete ${widget.className}?',
          style: TextStyle(fontSize: 17.0),
        ),
      ),
      titlePadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      contentPadding: EdgeInsets.all(10.0),
      actions: [
        /// cancel button
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Cancel',
            style: TextStyle(color: ColorThemes.primaryColor),
          ),
        ),

        /// delete button
        TextButton(
          onPressed: () {
            widget.delete();
            Navigator.pop(context);
          },
          child: Text(
            'Delete',
            style: TextStyle(color: ColorThemes.primaryColor),
          ),
        )
      ],
    );
  }
}
