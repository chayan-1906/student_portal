import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_portal/models/question_model.dart';

class SchoolModel {
  String authenticatedBy;
  String createdAt;
  String email;
  // String joinedAt;
  String id;
  String school_name;
  // List questions;
  int studentsCount;

  SchoolModel({
    this.authenticatedBy,
    this.createdAt,
    this.email,
    // this.joinedAt,
    this.id,
    this.school_name,
    // this.questions,
    this.studentsCount,
  });

  factory SchoolModel.fromDocument(QueryDocumentSnapshot queryDocumentSnapshot) {
    return SchoolModel(
      authenticatedBy: queryDocumentSnapshot.get('authenticatedBy'),
      createdAt: queryDocumentSnapshot.get('createdAt'),
      email: queryDocumentSnapshot.get('email'),
      // joinedAt: queryDocumentSnapshot.get('joinedAt'),
      id: queryDocumentSnapshot.get('id'),
      school_name: queryDocumentSnapshot.get('school_name'),
      // questions: queryDocumentSnapshot.get('questions'),
      studentsCount: queryDocumentSnapshot.get('students_count'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'authenticatedBy': authenticatedBy,
      'createdAt': createdAt,
      'email': email,
      // 'joinedAt': joinedAt,
      'id': id,
      'school_name': school_name,
      // 'questions': questions,
      'students_count': studentsCount,
    };
  }
}
