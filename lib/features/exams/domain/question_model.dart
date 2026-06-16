class QuestionModel {
  final String id;
  final String category; // Police, Banking, Railway, SSC, Groups, TSPSC, APPSC, UPSC
  final String questionEn;
  final String questionTe;
  final List<String> optionsEn;
  final List<String> optionsTe;
  final int correctOptionIndex; // 0 to 3
  final String explanationEn;
  final String explanationTe;

  QuestionModel({
    required this.id,
    required this.category,
    required this.questionEn,
    required this.questionTe,
    required this.optionsEn,
    required this.optionsTe,
    required this.correctOptionIndex,
    required this.explanationEn,
    required this.explanationTe,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'questionEn': questionEn,
      'questionTe': questionTe,
      'optionsEn': optionsEn,
      'optionsTe': optionsTe,
      'correctOptionIndex': correctOptionIndex,
      'explanationEn': explanationEn,
      'explanationTe': explanationTe,
    };
  }

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      id: map['id'] ?? '',
      category: map['category'] ?? '',
      questionEn: map['questionEn'] ?? '',
      questionTe: map['questionTe'] ?? '',
      optionsEn: List<String>.from(map['optionsEn'] ?? []),
      optionsTe: List<String>.from(map['optionsTe'] ?? []),
      correctOptionIndex: map['correctOptionIndex'] ?? 0,
      explanationEn: map['explanationEn'] ?? '',
      explanationTe: map['explanationTe'] ?? '',
    );
  }
}
