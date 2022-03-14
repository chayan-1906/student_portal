import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Constants {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  static CollectionReference schoolsReference =
      firebaseFirestore.collection('schools');
  static CollectionReference questionsReference = firebaseFirestore
      .collection('schools')
      .doc(firebaseAuth.currentUser.uid)
      .collection('questions');
  // static CollectionReference schoolsReference = firebaseFirestore.collection('schools');
}
