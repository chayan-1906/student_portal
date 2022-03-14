import 'package:flutter/material.dart';
import 'package:student_portal/services/color_themes.dart';

class ShowCancelAlertBox extends StatefulWidget {
  final Function() reset;
  const ShowCancelAlertBox({Key key, this.reset}) : super(key: key);

  @override
  _ShowCancelAlertBoxState createState() => _ShowCancelAlertBoxState();
}

class _ShowCancelAlertBoxState extends State<ShowCancelAlertBox> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              size: 50.0,
              color: ColorThemes.primaryColor,
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Discard your Changes?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      titlePadding:
          const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      contentPadding: EdgeInsets.all(10.0),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel', style: TextStyle(color: Colors.grey[800])),
        ),
        ElevatedButton(
          onPressed: () {
            widget.reset();
            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: Text('Okay', style: TextStyle(color: Colors.white)),
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(ColorThemes.primaryColor),
          ),
        )
      ],
    );
  }
}
