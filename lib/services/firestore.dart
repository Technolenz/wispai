import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save user info to Firestore
  Future<void> saveUserInfo({
    required String userId,
    required String name,
    required String geminiApiKey,
    String? bio,
  }) async {
    await _firestore.collection('users').doc(userId).set({
      'name': name,
      'geminiApiKey': geminiApiKey,
      'bio': bio,
      'lastLogin': Timestamp.now(), // Store the last login timestamp
    });
  }

  // Get user info from Firestore
  Future<Map<String, dynamic>> getUserInfo(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    return doc.data() ?? {};
  }

  // Update last login timestamp
  Future<void> updateLastLogin(String userId) async {
    await _firestore.collection('users').doc(userId).update({
      'lastLogin': Timestamp.now(),
    });
  }

  Future<void> saveChatHistory({
    required String userId,
    required List<Map<String, String>> chatHistory,
  }) async {
    await _firestore.collection('users').doc(userId).collection('chatHistory').add({
      'timestamp': Timestamp.now(),
      'messages': chatHistory,
    });
  }
}
