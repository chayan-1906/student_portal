import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_portal/components/loading_spinkit_wave.dart';
import 'package:student_portal/models/class_model.dart';
import 'package:student_portal/services/class_id_list.dart';
import 'package:student_portal/services/class_name_map.dart';
import 'package:student_portal/services/color_themes.dart';

import '../components/show_saving_dialog.dart';
import '../services/global_methods.dart';
import 'class_list_screen.dart';

class AddClassScreen extends StatefulWidget {
  const AddClassScreen({Key key}) : super(key: key);

  @override
  _AddClassScreenState createState() => _AddClassScreenState();
}

class _AddClassScreenState extends State<AddClassScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference _classesReference;
  // Future _future;
  String generatedId = '';
  // TextEditingController _classNameController = TextEditingController();
  // TextEditingController _sectionNameController = TextEditingController();
  String selectedClass = '';
  List<String> _classes = [
    'Class - V',
    'Class - VI',
    'Class - VII',
    'Class - VIII',
    'Class - IX',
    'Class - X',
    'Class - XI',
    'Class - XII',
  ];
  String selectedSec = 'Section - A';
  List<String> _sections = [
    'Section - A',
    'Section - B',
    'Section - C',
    'Section - D',
    'Section - E',
  ];

  /*Future<void> getClassNames() async {
    ClassIdList.classIds.clear();
    ClassNameList.classNames.clear();
    // await getClassesList().then((value) {
    classesReference.get().then((querySnapshot) {
      querySnapshot.docs.forEach((element) {
        ClassIdList.classIds.add('${element['id']}');
      });
      print('34: ${ClassIdList.classIds}');
    });
    // });
  }

  Future<void> getClassesList() async {
    classesReference.get().then((querySnapshot) {
      querySnapshot.docs.forEach((element) {
        setState(() {
          ClassIdList.classIds.add('${element['id']}');
        });
      });
      print('34: ${ClassIdList.classIds}');
    });
  }*/

  refresh() {
    setState(() {
      _classesReference.snapshots();
    });
  }

  Future<dynamic> showClassCreationDialog(
      BuildContext context, double width) async {
    return showDialog(
      context: context,
      builder: (ctx) {
        selectedClass = '';
        return AlertDialog(
          elevation: 8.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          // backgroundColor: ColorThemes.primaryColor.withOpacity(0.3),
          title: Text(
            'Add Class',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: width * 0.06,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                /// name of class *
                Row(
                  children: [
                    const Text('Name of class '),
                    const Text(
                      '*',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),

                /// classname textformfield
                /*TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2.0,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.error,
                        width: 2.0,
                      ),
                    ),
                  ),
                  controller: _classNameController,
                ),*/
                DropdownButtonFormField2(
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        color: Theme.of(ctx).colorScheme.primary,
                        width: 2.0,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        color: Theme.of(ctx).colorScheme.error,
                        width: 2.0,
                      ),
                    ),
                  ),
                  isExpanded: true,
                  hint: Text('Select class', style: TextStyle(fontSize: 14.0)),
                  icon: Icon(Icons.arrow_drop_down, color: Colors.black45),
                  iconSize: 30.0,
                  buttonHeight: 60.0,
                  buttonPadding: const EdgeInsets.only(left: 20.0, right: 10.0),
                  dropdownDecoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(15.0)),
                  items: _classes
                      .map(
                        (item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(item, style: TextStyle(fontSize: 14.0)),
                        ),
                      )
                      .toList(),
                  validator: (_class) {
                    if (_class == null) {
                      return 'Please select class';
                    }
                    return null;
                  },
                  onChanged: (_class) {
                    selectedClass = _class.toString();
                  },
                  // onSaved: (_class) {
                  //   selectedClass = _class.toString();
                  // },
                ),
                const SizedBox(height: 10.0),

                /// name of section
                const Text('Name of section'),
                const SizedBox(height: 10.0),
                DropdownButtonFormField2(
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        color: Theme.of(ctx).colorScheme.primary,
                        width: 2.0,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        color: Theme.of(ctx).colorScheme.error,
                        width: 2.0,
                      ),
                    ),
                  ),
                  isExpanded: true,
                  hint:
                      Text('Select section', style: TextStyle(fontSize: 14.0)),
                  icon: Icon(Icons.arrow_drop_down, color: Colors.black45),
                  iconSize: 30.0,
                  buttonHeight: 60.0,
                  buttonPadding: const EdgeInsets.only(left: 20.0, right: 10.0),
                  dropdownDecoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(15.0)),
                  items: _sections
                      .map(
                        (item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(item, style: TextStyle(fontSize: 14.0)),
                        ),
                      )
                      .toList(),
                  onChanged: (_section) {
                    selectedSec = _section.toString();
                  },
                  // onSaved: (_section) {
                  //   selectedSec = _section.toString();
                  // },
                ),
              ],
            ),
          ),
          actions: [
            /// cancel button
            TextButton(
                child: Text(
                  'Cancel',
                  style:
                      TextStyle(color: ColorThemes.errorColor, fontSize: 17.0),
                ),
                onPressed: () async {
                  selectedClass = '';
                  selectedSec = '';
                  Navigator.pop(ctx);
                }),

            /// add button
            TextButton(
              child: Text(
                'Add',
                style:
                    TextStyle(color: ColorThemes.primaryColor, fontSize: 17.0),
              ),
              onPressed: () async {
                print(selectedClass);
                if (selectedClass != '') {
                  Navigator.pop(context);
                  ShowSavingDialog(context: context, text: 'Adding');
                  GlobalMethods.addNewClass(
                    context: context,
                    selectedClass: selectedClass,
                    selectedSec: selectedSec,
                    classesReference: _classesReference,
                  ).then((value) {
                    print('Class created');
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            '$selectedClass ${selectedSec.split('Section - ')[1]} created'),
                        backgroundColor: ColorThemes.primaryColor,
                        duration: Duration(seconds: 3),
                      ),
                    );
                  });
                } else {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(
                      content: Text('Please select a class'),
                      backgroundColor: ColorThemes.errorColor,
                      duration: Duration(seconds: 3),
                    ),
                  );
                  return;
                }
              },
            ),
          ],
        );
      },
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
    // _future = getClassNames();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Class'),
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: _classesReference.snapshots(),
          builder: (context, snapshot) {
            ClassIdList.classIds.clear();
            ClassNames.classNames.clear();
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Stack(
                children: [
                  Container(width: width, height: height),
                  Positioned(
                    top: 0.0,
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: LoadingSpinkitWave(color: ColorThemes.primaryColor),
                  ),
                ],
              );
            }
            List classes = snapshot.data.docs.map((classId) {
              return ClassModel.fromDocument(classId);
            }).toList();
            classes.forEach((classInstance) {
              ClassIdList.classIds.add(classInstance.id);
              print(ClassIdList.classIds.length);
              for (var id in ClassIdList.classIds) {
                ClassNames.classNames[id] =
                    '${classes[ClassIdList.classIds.indexOf(id)].class_name} ${classes[ClassIdList.classIds.indexOf(id)].section_name}';
              }
            });
            if (ClassIdList.classIds.isEmpty) {
              return Center(
                child: Container(
                  padding: EdgeInsets.all(width * 0.07),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// There are no classes for this school
                      Text(
                        'There are no classes for this school',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: width * 0.05,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      /// add a new class
                      TextButton(
                        onPressed: () {
                          showClassCreationDialog(context, width);
                        },
                        child: Text(
                          'Add a new class',
                          style: TextStyle(
                            fontSize: width * 0.065,
                            fontWeight: FontWeight.w600,
                            color: ColorThemes.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return ClassListScreen(refreshParent: refresh);
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showClassCreationDialog(context, width);
        },
        elevation: 0.0,
        backgroundColor: ColorThemes.primaryColor,
        child: Icon(Icons.add_rounded),
      ),
    );
  }
}
