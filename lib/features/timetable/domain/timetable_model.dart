class TimetableDay {
  final String date; // YYYY-MM-DD
  final String time; // e.g. "09:00 AM - 11:00 AM"
  final String subject;
  final String topic;
  final bool isCompleted;

  TimetableDay({
    required this.date,
    required this.time,
    required this.subject,
    required this.topic,
    this.isCompleted = false,
  });

  TimetableDay copyWith({
    String? date,
    String? time,
    String? subject,
    String? topic,
    bool? isCompleted,
  }) {
    return TimetableDay(
      date: date ?? this.date,
      time: time ?? this.time,
      subject: subject ?? this.subject,
      topic: topic ?? this.topic,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'time': time,
      'subject': subject,
      'topic': topic,
      'isCompleted': isCompleted,
    };
  }

  factory TimetableDay.fromMap(Map<String, dynamic> map) {
    return TimetableDay(
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      subject: map['subject'] ?? '',
      topic: map['topic'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
    );
  }
}

class TimetableModel {
  final String id;
  final String userId;
  final String examCategory;
  final String startDate; // YYYY-MM-DD
  final String endDate; // YYYY-MM-DD
  final List<TimetableDay> days;

  TimetableModel({
    required this.id,
    required this.userId,
    required this.examCategory,
    required this.startDate,
    required this.endDate,
    required this.days,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'examCategory': examCategory,
      'startDate': startDate,
      'endDate': endDate,
      'days': days.map((x) => x.toMap()).toList(),
    };
  }

  factory TimetableModel.fromMap(Map<String, dynamic> map) {
    return TimetableModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      examCategory: map['examCategory'] ?? '',
      startDate: map['startDate'] ?? '',
      endDate: map['endDate'] ?? '',
      days: List<TimetableDay>.from(
        (map['days'] as List?)?.map((x) => TimetableDay.fromMap(x as Map<String, dynamic>)) ?? [],
      ),
    );
  }
}
