import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_page_transition/page_transition_type.dart';
import 'package:student_portal/components/loading_spinkit_wave.dart';
import 'package:student_portal/services/color_themes.dart';

import '../../models/school_model.dart';
import '../../services/global_methods.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  // var top = 0.0;
  String _schoolName = '';
  String _emailAddress = '';
  String _password = '';
  String _errorMsg = '';
  bool _obscureText = true;
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  bool _sameSchoolExists = false;
  bool _sameEmailExists = false;

  Future<void> _checkForSameSchoolName({@required String schoolName}) async {
    print(schoolName);
    // setState(() {
    //   _isLoading = true;
    // });
    await _firebaseFirestore.collection('schools').get().then((querySnapshot) {
      querySnapshot.docs.forEach((element) {
        print(element['school_name']);
        setState(() {
          _isLoading = true;
        });
        if (element['school_name'] == schoolName) {
          setState(() {
            _sameSchoolExists = true;
          });
          print('same school already exists');
        } else {
          print('same school not exists');
        }
      });
    });
  }

  Future<void> _checkForSameEmail({@required String email}) async {
    // setState(() {
    //   _isLoading = true;
    // });
    await _firebaseFirestore.collection('schools').get().then((querySnapshot) {
      querySnapshot.docs.forEach((element) {
        setState(() {
          _isLoading = true;
        });
        if (element['email'] == email) {
          setState(() {
            _sameEmailExists = true;
          });
          print('same email already exists');
        } else {
          print('same email not exists');
        }
      });
    });
  }

  Future<void> _submitForm() async {
    final isFormValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    // var date = DateTime.now().toString();
    // var dateParse = DateTime.parse(date);
    // var formattedDate = '${dateParse.day}-${dateParse.month}-${dateParse.year}';
    if (isFormValid) {
      _formKey.currentState.save();
      try {
        // setState(() {
        //   _isLoading = true;
        // });
        _checkForSameSchoolName(schoolName: _schoolName).then((value) async {
          print(_sameSchoolExists);
          if (_sameSchoolExists) {
            print('Same school exists, can\'t proceed');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$_schoolName already exists'),
                backgroundColor: Colors.redAccent,
                duration: Duration(seconds: 3),
              ),
            );
            setState(() {
              _isLoading = false;
            });
            return;
          }
          _checkForSameEmail(email: _emailAddress).then((value) async {
            print(_sameEmailExists);
            if (_sameEmailExists) {
              print('Same email exists, can\'t proceed');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$_emailAddress already exists'),
                  backgroundColor: Colors.redAccent,
                  duration: Duration(seconds: 3),
                ),
              );
              setState(() {
                _isLoading = false;
              });
              return;
            }
            await _firebaseAuth.createUserWithEmailAndPassword(
              email: _emailAddress.toLowerCase().trim(),
              password: _password.trim(),
            );
            final User user = _firebaseAuth.currentUser;
            final _uid = user.uid;
            var createdDate = user.metadata.creationTime.toString();
            user.updateDisplayName(_schoolName);
            user.reload();
            await FirebaseFirestore.instance
                .collection('schools')
                .doc(_uid)
                .set(SchoolModel(
                  authenticatedBy: 'email',
                  createdAt: createdDate,
                  email: _emailAddress,
                  // joinedAt: formattedDate,
                  id: _uid,
                  school_name: _schoolName,
                  studentsCount: 0,
                ).toMap());
            Navigator.canPop(context) ? Navigator.pop(context) : null;
          });
        });
        // Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      } catch (error) {
        // TODO: EMAIL_ALREADY_IN_USE no warning dialog is showing
        if (error.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
          print('errorCode: ${error.code}');
        }
        GlobalMethods.authErrorDialog(
          context,
          'Error Occurred',
          error.toString(),
        );
        print('error occurred: ${error.toString()}');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          Container(color: ColorThemes.errorColor),
          Positioned(
            bottom: height * 0.10,
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 20),
                    // spreadRadius: 50.0,
                    color: Color(0xFF7B2A42),
                    blurRadius: 10.0,
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(height * 0.36),
                  // bottomRight: Radius.circular(height * 0.60),
                ),
              ),
            ),
          ),

          /// form
          Column(
            children: [
              /// sign up
              Text(
                'Sign Up',
                style: TextStyle(
                  color: ColorThemes.errorColor,
                  fontSize: height * 0.08,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Form(
                key: _formKey,
                child: Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      SizedBox(height: 15.0),

                      /// textformfield school name
                      Padding(
                        padding: EdgeInsets.all(width * 0.05),
                        child: TextFormField(
                          key: const ValueKey('name'),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (name) {
                            if (name.isEmpty) {
                              return 'Please enter your school name';
                            } else {
                              return null;
                            }
                          },
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.name,
                          style: TextStyle(
                            // color: Colors.black,
                            fontSize: height * 0.03,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
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
                            labelText: 'School Name',
                            labelStyle: TextStyle(
                              fontSize: height * 0.03,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            hintText: 'Enter your school name...',
                            hintStyle: TextStyle(
                              fontSize: height * 0.03,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                            errorStyle: TextStyle(
                              fontSize: height * 0.02,
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w500,
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.redAccent,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            prefixIcon: Icon(MaterialIcons.school),
                            contentPadding: EdgeInsets.all(15.0),
                          ),
                          onSaved: (value) {
                            setState(() {
                              _schoolName = value;
                              _sameSchoolExists = false;
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              _schoolName = value;
                              _sameSchoolExists = false;
                            });
                          },
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_emailFocusNode),
                        ),
                      ),

                      /// textformfield email
                      Padding(
                        padding: EdgeInsets.all(width * 0.05),
                        child: TextFormField(
                          key: const ValueKey('email'),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (email) {
                            if (email.isEmpty || !email.contains('@')) {
                              _errorMsg = 'Please enter a valid email';
                            } else {
                              _errorMsg = null;
                            }
                            return _errorMsg;
                          },
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                            fontSize: height * 0.03,
                            fontWeight: FontWeight.w500,
                            // color: Theme.of(context).primaryColor,
                          ),
                          focusNode: _emailFocusNode,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
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
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              fontSize: height * 0.03,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            hintText: 'Enter your email...',
                            hintStyle: TextStyle(
                              fontSize: height * 0.03,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                            errorStyle: TextStyle(
                              fontSize: height * 0.02,
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w500,
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.redAccent,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            prefixIcon: Icon(MaterialCommunityIcons.email),
                            contentPadding: EdgeInsets.all(15.0),
                          ),
                          onSaved: (value) {
                            _emailAddress = value;
                            _sameEmailExists = false;
                          },
                          onChanged: (value) {
                            setState(() {
                              _sameEmailExists = false;
                            });
                          },
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_passwordFocusNode),
                        ),
                      ),

                      /// textformfield password
                      Padding(
                        padding: EdgeInsets.all(width * 0.05),
                        child: TextFormField(
                          key: const ValueKey('password'),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (password) {
                            if (password.isEmpty) {
                              _errorMsg = 'Please enter your password';
                            } else if (password.length < 6) {
                              _errorMsg =
                                  'Password should contain at least 6 characters';
                            } else {
                              _errorMsg = null;
                            }
                            return _errorMsg;
                          },
                          keyboardType: TextInputType.visiblePassword,
                          style: TextStyle(
                            fontSize: height * 0.03,
                            fontWeight: FontWeight.w500,
                            // color: Theme.of(context).primaryColor,
                          ),
                          focusNode: _passwordFocusNode,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
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
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              fontSize: height * 0.03,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            hintText: 'Enter your password...',
                            hintStyle: TextStyle(
                              fontSize: height * 0.03,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                            errorStyle: TextStyle(
                              fontSize: height * 0.02,
                              fontWeight: FontWeight.w500,
                              color: Colors.redAccent,
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.redAccent,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            prefixIcon: Icon(MaterialIcons.security),
                            contentPadding: EdgeInsets.all(15.0),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: _obscureText
                                  ? Icon(MaterialIcons.visibility)
                                  : Icon(MaterialIcons.visibility_off),
                            ),
                          ),
                          obscureText: _obscureText,
                          onSaved: (value) {
                            _password = value;
                          },
                        ),
                      ),

                      /// sign up
                      Padding(
                        padding: EdgeInsets.all(width * 0.05),
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 15.0),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                            ),
                          ),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: height * 0.035,
                            ),
                          ),
                        ),
                      ),

                      /// already have an account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: width * 0.05),
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                    child: LoginScreen(),
                                    type: PageTransitionType.rippleRightUp,
                                  ),
                                );
                              },
                              child: RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                    TextSpan(
                                      text: 'Already have an account?',
                                      style: TextStyle(
                                        fontSize: height * 0.025,
                                        color: ColorThemes.primaryColor,
                                        fontWeight: FontWeight.w500,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '\tLOG IN',
                                      style: TextStyle(
                                        fontSize: height * 0.03,
                                        color: ColorThemes.primaryColor,
                                        fontWeight: FontWeight.w700,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          /// while signing in loading
          Positioned(
            top: 0.0,
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Visibility(
              visible: _isLoading,
              child: LoadingSpinkitWave(color: ColorThemes.primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
