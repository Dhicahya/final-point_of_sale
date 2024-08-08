import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject_sanber/models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Create a new user
  Future<UserModel> createUser(UserModel user) async {
    final docRef = _firestore.collection('users').doc(); // Auto-generated ID
    await docRef.set(user.toJson());
    return user.copyWith(id: docRef.id); // Return user with the document ID
  }

  // Update user information
  Future<UserModel> updateUser(UserModel user, String userId) async {
    final docRef = _firestore.collection('users').doc(userId);
    await docRef.update(user.toJson());
    return user;
  }

  // Get user profile
  Future<UserModel> getUser(String userId) async {
    final docRef = _firestore.collection('users').doc(userId);
    final snapshot = await docRef.get();
    if (!snapshot.exists) throw Exception('User not found');
    return UserModel.fromJson(snapshot.data()!);
  }

  // Upload profile picture
  Future<String> uploadProfilePicture(String userId, File imageFile) async {
    final storageRef = _storage.ref().child('profile_pictures/$userId');
    final uploadTask = storageRef.putFile(imageFile);
    final snapshot = await uploadTask.whenComplete(() => {});
    return await snapshot.ref.getDownloadURL();
  }

  // User login
  Future<UserModel> loginUser(Map<String, String> credentials) async {
    // Replace with actual authentication logic if needed
    // This is a placeholder implementation
    final email = credentials['email'] ?? '';
    final password = credentials['password'] ?? '';

    final querySnapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .where('password', isEqualTo: password)
        .get();

    if (querySnapshot.docs.isEmpty) throw Exception('Invalid credentials');
    final userData = querySnapshot.docs.first.data();
    return UserModel.fromJson(userData);
  }
}
