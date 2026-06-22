import 'package:flutter/material.dart';
import '../../data/timetable_service.dart';
import '../../domain/timetable_model.dart';

class TimetableProvider extends ChangeNotifier {
  final TimetableService _timetableService = TimetableService();

  TimetableModel? _activeTimetable;
  bool _isLoading = false;
  String? _errorMessage;

  DateTime? _startDate = DateTime.now();
  DateTime? _endDate = DateTime.now().add(const Duration(days: 30));
  String _selectedExamCategory = 'Police SI';

  TimetableModel? get activeTimetable => _activeTimetable;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  String get selectedExamCategory => _selectedExamCategory;

  void setStartDate(DateTime date) {
    _startDate = date;
    notifyListeners();
  }

  void setEndDate(DateTime date) {
    _endDate = date;
    notifyListeners();
  }

  void setSelectedCategory(String category) {
    _selectedExamCategory = category;
    notifyListeners();
  }

  // Load user active timetable
  Future<void> loadActiveTimetable(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _activeTimetable = await _timetableService.getTimetable(userId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Generate a new timetable
  Future<bool> createTimetable({
    required String userId,
    required String langCode,
  }) async {
    if (_startDate == null || _endDate == null) {
      _errorMessage = "Please select both start and end dates";
      notifyListeners();
      return false;
    }

    if (_endDate!.isBefore(_startDate!)) {
      _errorMessage = "End date must be after start date";
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _activeTimetable = await _timetableService.generateTimetable(
        userId: userId,
        examCategory: _selectedExamCategory,
        startDate: _startDate!,
        endDate: _endDate!,
        langCode: langCode,
      );
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Toggle day's completion
  Future<void> toggleDay(int dayIndex) async {
    if (_activeTimetable == null) return;
    try {
      await _timetableService.toggleDayCompletion(_activeTimetable!, dayIndex);
      // reload
      _activeTimetable = await _timetableService.getTimetable(_activeTimetable!.userId);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
