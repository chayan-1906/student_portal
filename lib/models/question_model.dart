class QuestionModel {
  String classImage;
  int questionNumber;
  bool isOptional;
  String question;
  String questionType;
  List<String> validAnswers;
  String questionId;

  QuestionModel({
    this.classImage,
    this.questionNumber,
    this.isOptional,
    this.question,
    this.questionType,
    this.validAnswers,
    this.questionId,
  });

  factory QuestionModel.fromDocument(json) {
    return QuestionModel(
      classImage: json["classImage"],
      questionNumber: json["questionNumber"],
      isOptional: json["isOptional"],
      question: json["question"],
      questionType: json["questionType"],
      validAnswers: List.from(json["validAnswers"].map((x) => x)),
      questionId: json["questionId"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "classImage": classImage,
      "questionNumber": questionNumber,
      "isOptional": isOptional,
      "question": question,
      "questionType": questionType,
      "validAnswers": List<dynamic>.from(validAnswers.map((x) => x)),
      "questionId": questionId,
    };
  }
}

Map<String, dynamic> toMap(QuestionModel question) {
  return {
    'questionId': question.questionId,
    'classImage': question.classImage,
    'questionNumber': question.questionNumber,
    'isOptional': question.isOptional,
    'question': question.question,
    'questionType': question.questionType,
    'validAnswers': question.validAnswers,
  };
}
