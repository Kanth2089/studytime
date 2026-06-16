import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/firebase_config.dart';
import '../domain/user_model.dart';

class AuthService {
  FirebaseAuth get _firebaseAuth => FirebaseAuth.instance;
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  // Sign in
  Future<UserModel?> signIn(String email, String password) async {
    if (FirebaseConfig.isFirebaseAvailable) {
      try {
        final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email.trim(),
          password: password,
        );
        if (credential.user != null) {
          return await getUserData(credential.user!.uid);
        }
      } catch (e) {
        rethrow;
      }
    } else {
      // Mock Sign In
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString('mock_users') ?? '{}';
      final Map<String, dynamic> users = jsonDecode(usersJson);
      
      final lowerEmail = email.trim().toLowerCase();
      if (users.containsKey(lowerEmail)) {
        final userData = users[lowerEmail];
        if (userData['password'] == password) {
          final uid = userData['uid'];
          await prefs.setString('mock_current_uid', uid);
          return UserModel.fromMap(Map<String, dynamic>.from(userData));
        } else {
          throw Exception("Incorrect password");
        }
      } else {
        throw Exception("User not found");
      }
    }
    return null;
  }

  // Register
  Future<UserModel?> register({
    required String name,
    required String email,
    required String password,
    required String selectedGoal,
  }) async {
    final cleanEmail = email.trim();
    if (FirebaseConfig.isFirebaseAvailable) {
      try {
        final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: cleanEmail,
          password: password,
        );
        if (credential.user != null) {
          final userModel = UserModel(
            uid: credential.user!.uid,
            name: name.trim(),
            email: cleanEmail.toLowerCase(),
            selectedGoal: selectedGoal,
            studyStreak: 1,
            accuracyPercentage: 0.0,
            totalExamsAttempted: 0,
            weakSubjects: [],
            strongSubjects: [],
            weeklyPerformance: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
            testMarks: [],
          );
          
          await _firestore.collection('users').doc(userModel.uid).set(userModel.toMap());
          return userModel;
        }
      } catch (e) {
        rethrow;
      }
    } else {
      // Mock Register
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString('mock_users') ?? '{}';
      final Map<String, dynamic> users = jsonDecode(usersJson);
      
      final lowerEmail = cleanEmail.toLowerCase();
      if (users.containsKey(lowerEmail)) {
        throw Exception("Email already registered");
      }

      final uid = 'mock_uid_${DateTime.now().millisecondsSinceEpoch}';
      final userModel = UserModel(
        uid: uid,
        name: name.trim(),
        email: lowerEmail,
        selectedGoal: selectedGoal,
        studyStreak: 1,
        accuracyPercentage: 0.0,
        totalExamsAttempted: 0,
        weakSubjects: [],
        strongSubjects: [],
        weeklyPerformance: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
        testMarks: [],
      );

      final userMap = userModel.toMap();
      userMap['password'] = password; // store password locally for mock validation
      users[lowerEmail] = userMap;
      
      await prefs.setString('mock_users', jsonEncode(users));
      await prefs.setString('mock_current_uid', uid);
      return userModel;
    }
    return null;
  }

  // Get current user details
  Future<UserModel?> getCurrentUser() async {
    if (FirebaseConfig.isFirebaseAvailable) {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        return await getUserData(user.uid);
      }
    } else {
      final prefs = await SharedPreferences.getInstance();
      final uid = prefs.getString('mock_current_uid');
      if (uid != null) {
        final usersJson = prefs.getString('mock_users') ?? '{}';
        final Map<String, dynamic> users = jsonDecode(usersJson);
        for (var key in users.keys) {
          if (users[key]['uid'] == uid) {
            return UserModel.fromMap(Map<String, dynamic>.from(users[key]));
          }
        }
      }
    }
    return null;
  }

  // Get specific user data from Firestore
  Future<UserModel?> getUserData(String uid) async {
    if (!FirebaseConfig.isFirebaseAvailable) return null;
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data()!);
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
    return null;
  }

  // Update user profile info
  Future<void> updateUser(UserModel user) async {
    if (FirebaseConfig.isFirebaseAvailable) {
      await _firestore.collection('users').doc(user.uid).update(user.toMap());
    } else {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString('mock_users') ?? '{}';
      final Map<String, dynamic> users = jsonDecode(usersJson);
      final email = user.email.toLowerCase();
      if (users.containsKey(email)) {
        final password = users[email]['password']; // keep password intact
        final updatedMap = user.toMap();
        updatedMap['password'] = password;
        users[email] = updatedMap;
        await prefs.setString('mock_users', jsonEncode(users));
      }
    }
  }

  // Reset Password
  Future<void> resetPassword(String email) async {
    if (FirebaseConfig.isFirebaseAvailable) {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } else {
      // Mock reset
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString('mock_users') ?? '{}';
      final Map<String, dynamic> users = jsonDecode(usersJson);
      if (!users.containsKey(email.trim().toLowerCase())) {
        throw Exception("Email address not found");
      }
    }
  }

  // Send Email Verification
  Future<void> sendEmailVerification() async {
    if (FirebaseConfig.isFirebaseAvailable) {
      await _firebaseAuth.currentUser?.sendEmailVerification();
    }
  }

  // Check Email Verification Status
  Future<bool> isEmailVerified() async {
    if (FirebaseConfig.isFirebaseAvailable) {
      await _firebaseAuth.currentUser?.reload();
      return _firebaseAuth.currentUser?.emailVerified ?? false;
    }
    return true; // Auto verify in mock mode
  }

  // Sign out
  Future<void> signOut() async {
    if (FirebaseConfig.isFirebaseAvailable) {
      await _firebaseAuth.signOut();
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('mock_current_uid');
    }
  }
}
