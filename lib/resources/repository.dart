import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wild_boar/models/user.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:wild_boar/resources/firebase_provider.dart';

class Repository {
  final _firebaseProvider = FirebaseProvider();

  Future<void> addDataToDb(FirebaseUser user) =>
      _firebaseProvider.addDataToDb(user);

  Future<FirebaseUser> signIn() => _firebaseProvider.signIn();

  Future<bool> authenticateUser(FirebaseUser user) =>
      _firebaseProvider.authenticateUser(user);

  Future<void> signOut() => _firebaseProvider.signOut();

  Future<FirebaseUser> getCurrentUser() => _firebaseProvider.getCurrentUser();

  Future<String> uploadImageToStorage(File imageFile) =>
      _firebaseProvider.uploadImageToStorage(imageFile);

  Future<List<DocumentSnapshot>> fetchStats({String uid, String label}) =>
      _firebaseProvider.fetchStats(uid: uid, label: label);

  Future<void> updatePhoto(String photoUrl, String uid) =>
      _firebaseProvider.updatePhoto(photoUrl, uid);

  Future<void> updateDetails(String uid, String name, String phone) =>
      _firebaseProvider.updateDetails(uid, name, phone);

  Future<Users> retrieveUserDetails(FirebaseUser user) =>
      _firebaseProvider.retrieveUserDetails(user);

  //Future<List<DocumentSnapshot>> retrievePostByUID(String uid) => _firebaseProvider.retrievePostByUID(uid);
  Future<void> addReportToDb(
          Users currentUser,
          String coordinate,
          List<Asset> images,
          String status,
          String type,
          String handled,
          String description) =>
      _firebaseProvider.addReportToDb(
        currentUser,
        coordinate,
        images,
        status,
        type,
        handled,
        description,
      );
  Future<Users> fetchUserDetailsById(String uid) =>
      _firebaseProvider.fetchUserDetailsById(uid);

  Future<List<String>> retrieveUserReport(String userId) =>
      _firebaseProvider.retrieveUserReport(userId);

  Future<List<DocumentSnapshot>> fetchReport(FirebaseUser user) =>
      _firebaseProvider.fetchReport(user);

  Future<List<DocumentSnapshot>> fetchAllReport() =>
      _firebaseProvider.fetchAllReport();
}
