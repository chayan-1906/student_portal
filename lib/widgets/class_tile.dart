import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:student_portal/services/class_name_map.dart';
import 'package:student_portal/services/color_themes.dart';

import '../components/show_delete_dialog.dart';
import '../components/show_delete_alert_dialog.dart';
import '../screens/question_list_edit_screen.dart';

class ClassTile extends StatefulWidget {
  final Function() refreshGrandParent;
  final int index;

  const ClassTile({
    Key key,
    this.refreshGrandParent,
    this.index,
  }) : super(key: key);

  @override
  _ClassTileState createState() => _ClassTileState();
}

class _ClassTileState extends State<ClassTile> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference _classesReference;

  void editClass({
    @required BuildContext context,
    @required Function() refresh,
    @required String title,
    @required String id,
  }) {
    Navigator.push(
      context,
      PageTransition(
        child: QuestionListEditScreen(
          refreshParentWidgetWhilePop: refresh,
          id: id,
          title: title,
        ),
        type: PageTransitionType.rippleRightUp,
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _classesReference = _firebaseFirestore
        .collection('schools')
        .doc(_firebaseAuth.currentUser.uid)
        .collection('classes');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: TextButton(
              onPressed: () {
                editClass(
                  context: context,
                  refresh: widget.refreshGrandParent,
                  title: ClassNames.classNames.values.elementAt(widget.index),
                  id: ClassNames.classNames.keys.elementAt(widget.index),
                );
              },
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// class symbol
                  CircleAvatar(
                    radius: 23.0,
                    backgroundColor: [
                      ColorThemes.primaryColor,
                      ColorThemes.secondaryColor
                    ][widget.index % 2],
                    foregroundColor: Colors.grey[800],
                    child: Text(
                      ClassNames.classNames.values
                          .elementAt(widget.index)
                          .split('Class - ')[1] // after Class -
                          .split(' ')[0] // till before section
                          .toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  SizedBox(width: 15.0),

                  /// class name
                  Text(
                    '${ClassNames.classNames.values.elementAt(widget.index).split('Section - ')[0]} ${ClassNames.classNames.values.elementAt(widget.index).split('Section - ')[1]}',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            /// delete
            IconSlideAction(
              caption: 'Delete',
              color: Colors.redAccent,
              icon: Icons.delete_rounded,
              foregroundColor: Colors.white,
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext ctx) {
                      return ShowDeleteAlertDialog(
                        delete: () async {
                          print(ClassNames.classNames.keys
                              .elementAt(widget.index));
                          Navigator.pop(context); // pop alert dialog
                          showDeletingDialog(context);
                          await _classesReference
                              .doc(ClassNames.classNames.keys
                                  .elementAt(widget.index))
                              .delete();
                          widget.refreshGrandParent();
                        },
                        className: ClassNames.classNames.values
                            .elementAt(widget.index),
                      );
                    });
              },
            ),
          ],
          secondaryActions: [
            IconSlideAction(
              caption: 'View',
              foregroundColor: Colors.white,
              color: widget.index % 2 == 0
                  ? ColorThemes.primaryColor
                  : ColorThemes.secondaryColor,
              icon: Icons.remove_red_eye_rounded,
              onTap: () {
                // TODO: Navigate to ViewScreen
                // Skywa Manager --> form_tile.dart Line 124
              },
            ),
          ],
        ),
      ],
    );
  }
}
