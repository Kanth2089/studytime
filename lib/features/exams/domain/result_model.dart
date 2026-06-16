class ResultModel {
  final String id;
  final String userId;
  final String category;
  final int score;
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final double accuracy;
  final String date; // YYYY-MM-DD
  final int durationSeconds;
  final Map<String, int> userAnswers; // questionId -> selectedOptionIndex

  ResultModel({
    required this.id,
    required this.userId,
    required this.category,
    required this.score,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.accuracy,
    required this.date,
    required this.durationSeconds,
    required this.userAnswers,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'category': category,
      'score': score,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'wrongAnswers': wrongAnswers,
      'accuracy': accuracy,
      'date': date,
      'durationSeconds': durationSeconds,
      'userAnswers': userAnswers,
    };
  }

  factory ResultModel.fromMap(Map<String, dynamic> map) {
    return ResultModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      category: map['category'] ?? '',
      score: map['score'] ?? 0,
      totalQuestions: map['totalQuestions'] ?? 0,
      correctAnswers: map['correctAnswers'] ?? 0,
      wrongAnswers: map['wrongAnswers'] ?? 0,
      accuracy: (map['accuracy'] as num?)?.toDouble() ?? 0.0,
      date: map['date'] ?? '',
      durationSeconds: map['durationSeconds'] ?? 0,
      userAnswers: Map<String, int>.from(map['userAnswers'] ?? {}),
    );
  }
}
