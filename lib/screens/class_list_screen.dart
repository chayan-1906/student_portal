import 'package:flutter/material.dart';
import 'package:student_portal/services/class_id_list.dart';
import 'package:student_portal/services/class_name_map.dart';
import 'package:student_portal/services/color_themes.dart';

import '../widgets/class_tile.dart';

class ClassListScreen extends StatefulWidget {
  final Function() refreshParent;

  const ClassListScreen({Key key, this.refreshParent}) : super(key: key);

  @override
  _ClassListScreenState createState() => _ClassListScreenState();
}

class _ClassListScreenState extends State<ClassListScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0.0),
        color: Colors.white,
      ),
      child: ListView.separated(
        itemCount: ClassNames.classNames.length,
        itemBuilder: (BuildContext context, int index) {
          return ClassTile(
            refreshGrandParent: widget.refreshParent,
            index: index,
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: ColorThemes.primaryColor, width: 1.0),
              ),
            ),
          );
        },
      ),
    );
  }
}
