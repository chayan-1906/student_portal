import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_portal/models/question_model.dart';

class ClassModel {
  String id;
  Timestamp createdAt;
  String class_name;
  String section_name;
  // List<QuestionModel> questions;
  // int studentsCount;

  ClassModel({
    this.id,
    this.createdAt,
    this.class_name,
    this.section_name,
    // this.questions,
    // this.studentsCount,
  });

  factory ClassModel.fromDocument(QueryDocumentSnapshot queryDocumentSnapshot) {
    return ClassModel(
      id: queryDocumentSnapshot.get('id'),
      createdAt: queryDocumentSnapshot.get('createdAt'),
      class_name: queryDocumentSnapshot.get('class_name'),
      section_name: queryDocumentSnapshot.get('section_name'),
      // questions: queryDocumentSnapshot.get('questions'),
      // studentsCount: queryDocumentSnapshot.get('studentsCount'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt,
      'class_name': class_name,
      'section_name': section_name,
      // 'questions': questions,
      // 'studentsCount': studentsCount,
    };
  }
}
