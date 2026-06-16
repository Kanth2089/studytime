import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/exams_service.dart';
import '../../domain/question_model.dart';
import '../../domain/result_model.dart';

class ExamsProvider extends ChangeNotifier {
  final ExamsService _examsService = ExamsService();

  List<QuestionModel> _questions = [];
  int _currentIndex = 0;
  final Map<String, int> _selectedAnswers = {}; // questionId -> selectedOptionIndex
  
  // Timer attributes
  int _remainingTimeSeconds = 600; // 10 minutes default
  Timer? _timer;
  
  bool _isLoading = false;
  bool _isExamCompleted = false;
  String? _errorMessage;
  ResultModel? _lastResult;

  List<QuestionModel> get questions => _questions;
  int get currentIndex => _currentIndex;
  Map<String, int> get selectedAnswers => _selectedAnswers;
  int get remainingTimeSeconds => _remainingTimeSeconds;
  bool get isLoading => _isLoading;
  bool get isExamCompleted => _isExamCompleted;
  String? get errorMessage => _errorMessage;
  ResultModel? get lastResult => _lastResult;

  String get formattedTime {
    final minutes = (_remainingTimeSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingTimeSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  // Start Exam
  Future<void> startExam(String category, String userId) async {
    _isLoading = true;
    _isExamCompleted = false;
    _currentIndex = 0;
    _selectedAnswers.clear();
    _remainingTimeSeconds = 600; // 10 minutes
    _lastResult = null;
    _errorMessage = null;
    notifyListeners();

    try {
      _questions = await _examsService.getQuestionsByCategory(category);
      if (_questions.isEmpty) {
        _errorMessage = "No questions found for this exam category.";
      } else {
        _startTimer(userId);
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _startTimer(String userId) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTimeSeconds > 0) {
        _remainingTimeSeconds--;
        notifyListeners();
      } else {
        submitExam(userId);
      }
    });
  }

  // Answer selection
  void selectOption(String questionId, int optionIndex) {
    if (_isExamCompleted) return;
    _selectedAnswers[questionId] = optionIndex;
    notifyListeners();
  }

  // Navigation
  void nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      notifyListeners();
    }
  }

  void previousQuestion() {
    if (_currentIndex > 0) {
      _currentIndex--;
      notifyListeners();
    }
  }

  void jumpToQuestion(int index) {
    if (index >= 0 && index < _questions.length) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  // Submit Exam
  Future<void> submitExam(String userId) async {
    if (_isExamCompleted || _questions.isEmpty) return;
    
    _timer?.cancel();
    _isExamCompleted = true;
    _isLoading = true;
    notifyListeners();

    int correct = 0;
    int wrong = 0;

    for (var question in _questions) {
      final selected = _selectedAnswers[question.id];
      if (selected != null) {
        if (selected == question.correctOptionIndex) {
          correct++;
        } else {
          wrong++;
        }
      } else {
        wrong++; // unanswered is counted as wrong/unscored
      }
    }

    final int score = correct * 10; // e.g. 10 marks per question
    final double accuracy = _questions.isNotEmpty 
        ? (correct / _questions.length) * 100 
        : 0.0;

    final today = DateTime.now();
    final todayStr = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    final result = ResultModel(
      id: 'res_${userId}_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      category: _questions.first.category,
      score: score,
      totalQuestions: _questions.length,
      correctAnswers: correct,
      wrongAnswers: wrong,
      accuracy: accuracy,
      date: todayStr,
      durationSeconds: 600 - _remainingTimeSeconds,
      userAnswers: Map<String, int>.from(_selectedAnswers),
    );

    try {
      await _examsService.saveResult(result);
      _lastResult = result;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Reset/Clear Exam state
  void resetExam() {
    _timer?.cancel();
    _questions.clear();
    _selectedAnswers.clear();
    _isExamCompleted = false;
    _currentIndex = 0;
    _lastResult = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
