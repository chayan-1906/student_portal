import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:student_portal/screens/auth/register_screen.dart';

import '../../components/loading_spinkit_wave.dart';
import '../../models/school_model.dart';
import '../../services/color_themes.dart';
import '../../services/global_methods.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _emailAddress = '';
  String _password = '';
  String _errorMsg = '';
  bool _obscureText = true;
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool _isLoading = false;

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    // var date = DateTime.now().toString();
    // var dateParse = DateTime.parse(date);
    // var formattedDate = '${dateParse.day}-${dateParse.month}-${dateParse.year}';
    if (isValid) {
      _formKey.currentState.save();
      try {
        setState(() {
          _isLoading = true;
        });
        await _firebaseAuth
            .signInWithEmailAndPassword(
          email: _emailAddress.toLowerCase().trim(),
          password: _password.trim(),
        )
            .then((value) {
          Navigator.canPop(context) ? Navigator.pop(context) : null;
        });
      } catch (error) {
        // TODO: EMAIL_ALREADY_IN_USE no warning dialog is showing
        print(error.code);
        if (error.code == 'user-not-found') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$_emailAddress not registered'),
              backgroundColor: Colors.redAccent,
              duration: Duration(seconds: 6),
            ),
          );
        } else if (error.code == 'wrong-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Wrong Password'),
              backgroundColor: Colors.redAccent,
              duration: Duration(seconds: 6),
            ),
          );
        } else {
          GlobalMethods.authErrorDialog(
            context,
            'Error Occurred',
            error.toString(),
          );
        }
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
      // backgroundColor: Colors.white,
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
              /// Login
              Text(
                'Login',
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

                      /// login
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
                            'Login',
                            style: TextStyle(
                              fontSize: height * 0.035,
                            ),
                          ),
                        ),
                      ),

                      /// don't have an account? Sign Up
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
                                    child: RegisterScreen(),
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
