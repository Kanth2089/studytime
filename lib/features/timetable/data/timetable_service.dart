import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/firebase_config.dart';
import '../../../../core/constants/syllabus_data.dart';
import '../domain/timetable_model.dart';

class TimetableService {
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  // Generate a timetable between dates
  Future<TimetableModel> generateTimetable({
    required String userId,
    required String examCategory,
    required DateTime startDate,
    required DateTime endDate,
    required String langCode,
  }) async {
    final List<TimetableDay> days = [];
    final subjects = SyllabusData.getSubjects(examCategory, langCode);
    
    if (subjects.isEmpty) {
      // Fallback if no subjects found
      subjects.addAll(['General Awareness', 'Reasoning', 'Aptitude']);
    }

    final int totalDays = endDate.difference(startDate).inDays + 1;
    final List<String> timeSlots = [
      "09:00 AM - 11:00 AM",
      "02:00 PM - 04:00 PM",
      "07:00 PM - 09:00 PM"
    ];

    int subjectIndex = 0;
    int topicIndexesMap = 0; // standard sequential circular index

    for (int i = 0; i < totalDays; i++) {
      final currentDayDate = startDate.add(Duration(days: i));
      final dateStr = "${currentDayDate.year}-${currentDayDate.month.toString().padLeft(2, '0')}-${currentDayDate.day.toString().padLeft(2, '0')}";
      
      // Select Subject
      final String subject = subjects[subjectIndex % subjects.length];
      
      // Select Topics for that subject
      final topics = SyllabusData.getTopics(examCategory, subject, langCode);
      final String topic = topics.isNotEmpty 
          ? topics[(topicIndexesMap) % topics.length] 
          : "General Study & Practice";

      // Create a daily schedule entry (can add multiple slots per day)
      final timeSlot = timeSlots[i % timeSlots.length];
      
      days.add(TimetableDay(
        date: dateStr,
        time: timeSlot,
        subject: subject,
        topic: topic,
        isCompleted: false,
      ));

      // Increment indices
      topicIndexesMap++;
      if (topicIndexesMap % 2 == 0) {
        subjectIndex++;
      }
    }

    final timetable = TimetableModel(
      id: "timetable_${userId}_${DateTime.now().millisecondsSinceEpoch}",
      userId: userId,
      examCategory: examCategory,
      startDate: "${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
      endDate: "${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
      days: days,
    );

    await saveTimetable(timetable);
    return timetable;
  }

  // Save timetable
  Future<void> saveTimetable(TimetableModel timetable) async {
    if (FirebaseConfig.isFirebaseAvailable) {
      await _firestore.collection('timetables').doc(timetable.userId).set(timetable.toMap());
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('mock_timetable_${timetable.userId}', jsonEncode(timetable.toMap()));
    }
  }

  // Get active timetable
  Future<TimetableModel?> getTimetable(String userId) async {
    if (FirebaseConfig.isFirebaseAvailable) {
      try {
        final doc = await _firestore.collection('timetables').doc(userId).get();
        if (doc.exists && doc.data() != null) {
          return TimetableModel.fromMap(doc.data()!);
        }
      } catch (e) {
        print("Error getting timetable: $e");
      }
    } else {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString('mock_timetable_$userId');
      if (data != null) {
        return TimetableModel.fromMap(jsonDecode(data));
      }
    }
    return null;
  }

  // Toggle timetable day status
  Future<void> toggleDayCompletion(TimetableModel timetable, int dayIndex) async {
    final updatedDays = List<TimetableDay>.from(timetable.days);
    final day = updatedDays[dayIndex];
    updatedDays[dayIndex] = day.copyWith(isCompleted: !day.isCompleted);
    
    final updatedTimetable = TimetableModel(
      id: timetable.id,
      userId: timetable.userId,
      examCategory: timetable.examCategory,
      startDate: timetable.startDate,
      endDate: timetable.endDate,
      days: updatedDays,
    );

    await saveTimetable(updatedTimetable);
  }
}
