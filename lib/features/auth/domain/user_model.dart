class UserModel {
  final String uid;
  final String name;
  final String email;
  final String selectedGoal;
  final int studyStreak;
  final double accuracyPercentage;
  final int totalExamsAttempted;
  final List<String> weakSubjects;
  final List<String> strongSubjects;
  final List<double> weeklyPerformance; // Stores study hours or test scores for 7 days
  final List<int> testMarks; // History of test marks

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.selectedGoal,
    this.studyStreak = 0,
    this.accuracyPercentage = 0.0,
    this.totalExamsAttempted = 0,
    this.weakSubjects = const [],
    this.strongSubjects = const [],
    this.weeklyPerformance = const [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
    this.testMarks = const [],
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? selectedGoal,
    int? studyStreak,
    double? accuracyPercentage,
    int? totalExamsAttempted,
    List<String>? weakSubjects,
    List<String>? strongSubjects,
    List<double>? weeklyPerformance,
    List<int>? testMarks,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      selectedGoal: selectedGoal ?? this.selectedGoal,
      studyStreak: studyStreak ?? this.studyStreak,
      accuracyPercentage: accuracyPercentage ?? this.accuracyPercentage,
      totalExamsAttempted: totalExamsAttempted ?? this.totalExamsAttempted,
      weakSubjects: weakSubjects ?? this.weakSubjects,
      strongSubjects: strongSubjects ?? this.strongSubjects,
      weeklyPerformance: weeklyPerformance ?? this.weeklyPerformance,
      testMarks: testMarks ?? this.testMarks,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'selectedGoal': selectedGoal,
      'studyStreak': studyStreak,
      'accuracyPercentage': accuracyPercentage,
      'totalExamsAttempted': totalExamsAttempted,
      'weakSubjects': weakSubjects,
      'strongSubjects': strongSubjects,
      'weeklyPerformance': weeklyPerformance,
      'testMarks': testMarks,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      selectedGoal: map['selectedGoal'] ?? '',
      studyStreak: map['studyStreak'] ?? 0,
      accuracyPercentage: (map['accuracyPercentage'] as num?)?.toDouble() ?? 0.0,
      totalExamsAttempted: map['totalExamsAttempted'] ?? 0,
      weakSubjects: List<String>.from(map['weakSubjects'] ?? []),
      strongSubjects: List<String>.from(map['strongSubjects'] ?? []),
      weeklyPerformance: List<double>.from(
        (map['weeklyPerformance'] as List?)?.map((e) => (e as num).toDouble()) ?? [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
      ),
      testMarks: List<int>.from(map['testMarks'] ?? []),
    );
  }
}
