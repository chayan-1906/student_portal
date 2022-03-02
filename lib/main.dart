import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_portal/services/color_themes.dart';

import 'screens/splash_screen.dart';
import 'services/user_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _firebaseInitialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _firebaseInitialization,
        builder: (context, snapshot) {
          return MaterialApp(
            title: 'Student Portal',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              appBarTheme: AppBarTheme(
                color: ColorThemes.primaryColor,
                centerTitle: true,
                titleTextStyle: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                  // letterSpacing: 1.5,
                ),
              ),
              primaryColor: ColorThemes.primaryColor,
              colorScheme: ColorScheme.fromSwatch().copyWith(
                primary: ColorThemes.primaryColor,
                secondary: ColorThemes.secondaryColor,
                error: ColorThemes.errorColor,
              ),
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: SplashScreen(),
            routes: {
              UserState.routeName: (ctx) => UserState(),
              // UserDetails.routeName: (ctx) => UserDetails(),
            },
          );
        });
  }
}
