import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wisp_ai/exports.dart'; // Your existing imports

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  // Stream to listen to authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch user data by userId
  Future<Map<String, dynamic>> getUserData(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return doc.data() ?? {}; // Return user data as a Map
      } else {
        throw Exception('User document not found');
      }
    } catch (e) {
      throw Exception('Failed to fetch user data: $e');
    }
  }

  Future<User?> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Send email verification
      await result.user?.sendEmailVerification();

      // Save basic user info to Firestore (name only)
      await _firestoreService.saveUserInfo(
        userId: result.user!.uid,
        name: name,
        geminiApiKey: '', // Empty for now, will be filled in UserInfoScreen
        bio: null, // Optional, can be filled later
      );

      return result.user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'An error occurred during sign-up.');
    }
  }

  Future<void> updateUserData({
    required String userId,
    String? name,
    String? geminiApiKey,
    String? bio,
  }) async {
    try {
      final userData = <String, dynamic>{};
      if (name != null) userData['name'] = name;
      if (geminiApiKey != null) userData['geminiApiKey'] = geminiApiKey;
      if (bio != null) userData['bio'] = bio;

      await _firestore.collection('users').doc(userId).update(userData);
    } catch (e) {
      throw Exception('Failed to update user data: $e');
    }
  }

  // Sign in with email and password
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if email is verified
      if (!result.user!.emailVerified) {
        await _auth.signOut(); // Sign out if email is not verified
        throw AuthException('Please verify your email before signing in.');
      }

      // Update last login timestamp in Firestore
      await _firestoreService.updateLastLogin(result.user!.uid);

      return result.user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'An error occurred during sign-in.');
    }
  }

  // Check if the user needs to sign in again
  Future<bool> needsSignIn(String userId) async {
    final userInfo = await _firestoreService.getUserInfo(userId);
    final lastLogin = userInfo['lastLogin'] as Timestamp?;

    if (lastLogin == null) return true; // First-time login

    final now = DateTime.now();
    final lastLoginDate = lastLogin.toDate();
    final difference = now.difference(lastLoginDate).inDays;

    return difference >= 7; // Sign in again after 7 days
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}

// Custom exception for authentication errors
class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}
