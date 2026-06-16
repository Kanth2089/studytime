import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/firebase_config.dart';
import '../domain/question_model.dart';
import '../domain/result_model.dart';
import '../../auth/domain/user_model.dart';

class ExamsService {
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  static final List<QuestionModel> _defaultQuestions = [
    // POLICE
    QuestionModel(
      id: 'q1',
      category: 'Police',
      questionEn: 'Which section of Indian Penal Code deals with punishment of abetment?',
      questionTe: 'భారతీయ శిక్షాస్మృతి ఏ సెక్షన్ ప్రేరేపణ శిక్ష గురించి తెలియజేస్తుంది?',
      optionsEn: ['Section 109', 'Section 120', 'Section 302', 'Section 376'],
      optionsTe: ['సెక్షన్ 109', 'సెక్షన్ 120', 'సెక్షన్ 302', 'సెక్షన్ 376'],
      correctOptionIndex: 0,
      explanationEn: 'Section 109 of IPC deals with the punishment of abetment if the act abetted is committed in consequence.',
      explanationTe: 'ప్రేరేపించబడిన చర్య దాని పర్యవసానంగా జరిగితే, ప్రేరేపణ శిక్ష గురించి ఐపిసి సెక్షన్ 109 వివరిస్తుంది.',
    ),
    QuestionModel(
      id: 'q2',
      category: 'Police',
      questionEn: 'Who is the highest ranking police officer in a Indian State?',
      questionTe: 'భారతీయ రాష్ట్రంలో అత్యున్నత స్థాయి పోలీస్ అధికారి ఎవరు?',
      optionsEn: ['Superintendent of Police (SP)', 'Director General of Police (DGP)', 'Commissioner of Police', 'Inspector General of Police (IGP)'],
      optionsTe: ['సూపరింటెండెంట్ ఆఫ్ పోలీస్ (SP)', 'డైరెక్టర్ జనరల్ ఆఫ్ పోలీస్ (DGP)', 'పోలీస్ కమిషనర్', 'ఇన్‌స్పెక్టర్ జనరల్ ఆఫ్ పోలీస్ (IGP)'],
      correctOptionIndex: 1,
      explanationEn: 'The Director General of Police (DGP) is a three-star rank and the highest-ranking police officer in Indian States and Union Territories.',
      explanationTe: 'డైరెక్టర్ జనరల్ ఆఫ్ పోలీస్ (DGP) త్రీ-స్టార్ ర్యాంక్ మరియు భారతీయ రాష్ట్రాలు మరియు కేంద్రపాలిత ప్రాంతాలలో అత్యున్నత పోలీస్ అధికారి.',
    ),

    // BANKING
    QuestionModel(
      id: 'q3',
      category: 'Banking',
      questionEn: 'What is the full form of RTGS in banking?',
      questionTe: 'బ్యాంకింగ్‌లో RTGS పూర్తి రూపం ఏమిటి?',
      optionsEn: ['Real Time Gross Settlement', 'Regional Transaction Gross System', 'Real Transaction General Service', 'Registered Transfer Gross Scheme'],
      optionsTe: ['రియల్ టైమ్ గ్రాస్ సెటిల్మెంట్', 'రీజినల్ ట్రాన్సాక్షన్ గ్రాస్ సిస్టమ్', 'రియల్ ట్రాన్సాక్షన్ జనరల్ సర్వీస్', 'రిజిస్టర్డ్ ట్రాన్స్‌ఫర్ గ్రాస్ స్కీమ్'],
      correctOptionIndex: 0,
      explanationEn: 'RTGS stands for Real Time Gross Settlement, which is a continuous and real-time settlement of fund-transfers.',
      explanationTe: 'RTGS అనగా రియల్ టైమ్ గ్రాస్ సెటిల్మెంట్. ఇది నిరంతరం మరియు నిజ సమయ నిధుల బదిలీ ప్రక్రియ.',
    ),

    // RAILWAY
    QuestionModel(
      id: 'q4',
      category: 'Railway',
      questionEn: 'In which year did the first passenger train run in India?',
      questionTe: 'భారతదేశంలో మొదటి ప్రయాణీకుల రైలు ఏ సంవత్సరంలో నడిచింది?',
      optionsEn: ['1850', '1853', '1890', '1901'],
      optionsTe: ['1850', '1853', '1890', '1901'],
      correctOptionIndex: 1,
      explanationEn: 'The first passenger train in India ran between Bori Bunder (Bombay) and Thane on 16 April 1853.',
      explanationTe: 'భారతదేశంలో మొదటి ప్రయాణీకుల రైలు 1853 ఏప్రిల్ 16 న బోరి బందర్ (బాంబే) మరియు థానే మధ్య నడిచింది.',
    ),

    // SSC
    QuestionModel(
      id: 'q5',
      category: 'SSC',
      questionEn: 'Which of the following is the fundamental unit of temperature?',
      questionTe: 'క్రింది వాటిలో ఉష్ణోగ్రత యొక్క ప్రాథమిక ప్రమాణం ఏది?',
      optionsEn: ['Celsius', 'Kelvin', 'Fahrenheit', 'Calorie'],
      optionsTe: ['సెల్సియస్', 'కెల్విన్', 'ఫారెన్‌హీట్', 'క్యాలరీ'],
      correctOptionIndex: 1,
      explanationEn: 'Kelvin (K) is the SI base unit of thermodynamic temperature.',
      explanationTe: 'థర్మోడైనమిక్ ఉష్ణోగ్రత యొక్క SI ప్రాథమిక ప్రమాణం కెల్విన్ (K).',
    ),

    // GROUPS
    QuestionModel(
      id: 'q6',
      category: 'Groups',
      questionEn: 'Who is known as the father of Indian Constitution?',
      questionTe: 'భారత రాజ్యాంగ పితామహుడిగా ఎవరిని పేర్కొంటారు?',
      optionsEn: ['Mahatma Gandhi', 'Dr. B.R. Ambedkar', 'Jawaharlal Nehru', 'Dr. Rajendra Prasad'],
      optionsTe: ['మహాత్మా గాంధీ', 'డా. బి.ఆర్. అంబేద్కర్', 'జవహర్‌లాల్ నెహ్రూ', 'డా. రాజేంద్ర ప్రసాద్'],
      correctOptionIndex: 1,
      explanationEn: 'Dr. Bhimrao Ramji Ambedkar is recognized as the chief architect and father of the Constitution of India.',
      explanationTe: 'డా. భీమ్‌రావ్ రామ్‌జీ అంబేద్కర్ భారతదేశ రాజ్యాంగ ప్రధాన శిల్పి మరియు పితామహుడిగా గుర్తించబడ్డారు.',
    ),

    // TSPSC
    QuestionModel(
      id: 'q7',
      category: 'TSPSC',
      questionEn: 'In which year was the Hyderabad state officially annexed into the Indian Union?',
      questionTe: 'హైదరాబాద్ రాష్ట్రం అధికారికంగా ఏ సంవత్సరంలో భారత యూనియన్‌లో విలీనమైంది?',
      optionsEn: ['1947', '1948', '1950', '1956'],
      optionsTe: ['1947', '1948', '1950', '1956'],
      correctOptionIndex: 1,
      explanationEn: 'Hyderabad State was annexed into the Indian Union in September 1948 following Operation Polo.',
      explanationTe: 'ఆపరేషన్ పోలో ద్వారా 1948 సెప్టెంబర్‌లో హైదరాబాద్ రాష్ట్రం భారత యూనియన్‌లో విలీనమైంది.',
    ),

    // APPSC
    QuestionModel(
      id: 'q8',
      category: 'APPSC',
      questionEn: 'Which city was selected as the new capital of Andhra Pradesh post-bifurcation in 2014?',
      questionTe: '2014 విభజన తర్వాత ఆంధ్రప్రదేశ్ నూతన రాజధానిగా ఏ నగరం ఎంపిక చేయబడింది?',
      optionsEn: ['Visakhapatnam', 'Vijayawada', 'Amaravati', 'Kurnool'],
      optionsTe: ['విశాఖపట్నం', 'విజయవాడ', 'అమరావతి', 'కర్నూలు'],
      correctOptionIndex: 2,
      explanationEn: 'Amaravati was initially declared as the capital of Andhra Pradesh post-bifurcation.',
      explanationTe: 'ఆంధ్రప్రదేశ్ విభజన తర్వాత అమరావతిని ఆంధ్రప్రదేశ్ రాజధానిగా ప్రకటించారు.',
    ),

    // UPSC
    QuestionModel(
      id: 'q9',
      category: 'UPSC',
      questionEn: 'Which Article of the Indian Constitution empowers the President to impose President Rule in a State?',
      questionTe: 'రాష్ట్రపతి పాలన విధించడానికి రాష్ట్రపతికి అధికారం ఇచ్చే భారత రాజ్యాంగ నిబంధన ఏది?',
      optionsEn: ['Article 352', 'Article 356', 'Article 360', 'Article 370'],
      optionsTe: ['నిబంధన 352', 'నిబంధన 356', 'నిబంధన 360', 'నిబంధన 370'],
      correctOptionIndex: 1,
      explanationEn: 'Article 356 provides for the imposition of President Rule in a state in case of failure of constitutional machinery.',
      explanationTe: 'రాజ్యాంగ యంత్రాంగం విఫలమైనప్పుడు రాష్ట్రంలో రాష్ట్రపతి పాలన విధించే అధికారాన్ని ఆర్టికల్ 356 కల్పిస్తుంది.',
    ),
  ];

  // Seed database if empty
  Future<void> initializeQuestions() async {
    if (FirebaseConfig.isFirebaseAvailable) {
      try {
        final collection = _firestore.collection('questions');
        final query = await collection.limit(1).get();
        if (query.docs.isEmpty) {
          for (var question in _defaultQuestions) {
            await collection.doc(question.id).set(question.toMap());
          }
        }
      } catch (e) {
        print("Error initializing questions in Firestore: $e");
      }
    } else {
      final prefs = await SharedPreferences.getInstance();
      final String? questionsJson = prefs.getString('mock_questions');
      if (questionsJson == null) {
        final questionsMapList = _defaultQuestions.map((e) => e.toMap()).toList();
        await prefs.setString('mock_questions', jsonEncode(questionsMapList));
      }
    }
  }

  // Fetch questions by category
  Future<List<QuestionModel>> getQuestionsByCategory(String category) async {
    await initializeQuestions();
    
    if (FirebaseConfig.isFirebaseAvailable) {
      try {
        final query = await _firestore
            .collection('questions')
            .where('category', isEqualTo: category)
            .get();
        return query.docs.map((doc) => QuestionModel.fromMap(doc.data())).toList();
      } catch (e) {
        print("Error fetching questions: $e");
      }
    }

    // Local mockup fallback
    final prefs = await SharedPreferences.getInstance();
    final String? questionsJson = prefs.getString('mock_questions');
    if (questionsJson != null) {
      final List<dynamic> list = jsonDecode(questionsJson);
      final allQuestions = list.map((item) => QuestionModel.fromMap(Map<String, dynamic>.from(item))).toList();
      return allQuestions.where((q) => q.category == category).toList();
    }
    
    return _defaultQuestions.where((q) => q.category == category).toList();
  }

  // Save Exam Result
  Future<void> saveResult(ResultModel result) async {
    if (FirebaseConfig.isFirebaseAvailable) {
      await _firestore.collection('results').doc(result.id).set(result.toMap());
    } else {
      final prefs = await SharedPreferences.getInstance();
      final String? resultsJson = prefs.getString('mock_results');
      final List<dynamic> list = resultsJson != null ? jsonDecode(resultsJson) : [];
      list.add(result.toMap());
      await prefs.setString('mock_results', jsonEncode(list));
    }
    await updateUserPerformanceStats(result.userId);
  }

  // Fetch results for User
  Future<List<ResultModel>> getUserResults(String userId) async {
    if (FirebaseConfig.isFirebaseAvailable) {
      try {
        final query = await _firestore
            .collection('results')
            .where('userId', isEqualTo: userId)
            .get();
        return query.docs.map((doc) => ResultModel.fromMap(doc.data())).toList();
      } catch (e) {
        print("Error getting results: $e");
      }
    }

    final prefs = await SharedPreferences.getInstance();
    final String? resultsJson = prefs.getString('mock_results');
    if (resultsJson != null) {
      final List<dynamic> list = jsonDecode(resultsJson);
      final allResults = list.map((item) => ResultModel.fromMap(Map<String, dynamic>.from(item))).toList();
      return allResults.where((r) => r.userId == userId).toList();
    }
    return [];
  }

  // Compute and update user performance statistics
  Future<void> updateUserPerformanceStats(String userId) async {
    final results = await getUserResults(userId);
    if (results.isEmpty) return;

    int totalAttempted = results.length;
    double totalAccuracySum = 0.0;
    List<int> testMarks = [];
    
    // Track category performance to find weak and strong subjects
    Map<String, int> correctByCat = {};
    Map<String, int> totalByCat = {};
    
    // Sort results by date/id to construct chronological performance lists
    results.sort((a, b) => a.date.compareTo(b.date));

    // Weekly performance holds the score of the last 7 exams (padded to 7 items)
    List<double> weeklyPerformance = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];

    for (int i = 0; i < results.length; i++) {
      final res = results[i];
      totalAccuracySum += res.accuracy;
      testMarks.add(res.score);
      
      // Update categories
      final cat = res.category;
      correctByCat[cat] = (correctByCat[cat] ?? 0) + res.correctAnswers;
      totalByCat[cat] = (totalByCat[cat] ?? 0) + res.totalQuestions;

      // Fit last 7 exams into weeklyPerformance
      int targetIdx = i - (results.length - 7);
      if (targetIdx >= 0 && targetIdx < 7) {
        weeklyPerformance[targetIdx] = res.score.toDouble();
      }
    }

    double averageAccuracy = totalAccuracySum / totalAttempted;

    // Identify weak and strong subjects based on category accuracy
    List<String> strongSubjects = [];
    List<String> weakSubjects = [];

    totalByCat.forEach((cat, total) {
      final correct = correctByCat[cat] ?? 0;
      final acc = (correct / total) * 100;
      if (acc >= 70.0) {
        strongSubjects.add(cat);
      } else {
        weakSubjects.add(cat);
      }
    });

    // Save back to SharedPreferences or Firestore user document
    if (FirebaseConfig.isFirebaseAvailable) {
      final userDoc = _firestore.collection('users').doc(userId);
      await userDoc.update({
        'totalExamsAttempted': totalAttempted,
        'accuracyPercentage': averageAccuracy,
        'testMarks': testMarks,
        'strongSubjects': strongSubjects,
        'weakSubjects': weakSubjects,
        'weeklyPerformance': weeklyPerformance,
      });
    } else {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString('mock_users') ?? '{}';
      final Map<String, dynamic> users = jsonDecode(usersJson);
      
      String? matchedEmail;
      users.forEach((email, data) {
        if (data['uid'] == userId) {
          matchedEmail = email;
        }
      });

      if (matchedEmail != null) {
        final userData = users[matchedEmail!];
        userData['totalExamsAttempted'] = totalAttempted;
        userData['accuracyPercentage'] = averageAccuracy;
        userData['testMarks'] = testMarks;
        userData['strongSubjects'] = strongSubjects;
        userData['weakSubjects'] = weakSubjects;
        userData['weeklyPerformance'] = weeklyPerformance;
        // Increment study streak if user did an exam
        userData['studyStreak'] = (userData['studyStreak'] ?? 0) + 1;
        
        users[matchedEmail!] = userData;
        await prefs.setString('mock_users', jsonEncode(users));
      }
    }
  }

  // Admin features: Add Question
  Future<void> addQuestion(QuestionModel question) async {
    if (FirebaseConfig.isFirebaseAvailable) {
      await _firestore.collection('questions').doc(question.id).set(question.toMap());
    } else {
      final prefs = await SharedPreferences.getInstance();
      final String? questionsJson = prefs.getString('mock_questions');
      final List<dynamic> list = questionsJson != null ? jsonDecode(questionsJson) : [];
      list.add(question.toMap());
      await prefs.setString('mock_questions', jsonEncode(list));
    }
  }

  // Admin features: Edit Question
  Future<void> editQuestion(QuestionModel question) async {
    if (FirebaseConfig.isFirebaseAvailable) {
      await _firestore.collection('questions').doc(question.id).update(question.toMap());
    } else {
      final prefs = await SharedPreferences.getInstance();
      final String? questionsJson = prefs.getString('mock_questions');
      if (questionsJson != null) {
        final List<dynamic> list = jsonDecode(questionsJson);
        final updatedList = list.map((item) {
          final map = Map<String, dynamic>.from(item);
          if (map['id'] == question.id) {
            return question.toMap();
          }
          return map;
        }).toList();
        await prefs.setString('mock_questions', jsonEncode(updatedList));
      }
    }
  }

  // Admin features: Delete Question
  Future<void> deleteQuestion(String questionId) async {
    if (FirebaseConfig.isFirebaseAvailable) {
      await _firestore.collection('questions').doc(questionId).delete();
    } else {
      final prefs = await SharedPreferences.getInstance();
      final String? questionsJson = prefs.getString('mock_questions');
      if (questionsJson != null) {
        final List<dynamic> list = jsonDecode(questionsJson);
        final updatedList = list.where((item) => item['id'] != questionId).toList();
        await prefs.setString('mock_questions', jsonEncode(updatedList));
      }
    }
  }
}
