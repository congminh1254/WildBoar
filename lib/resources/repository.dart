import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:wild_boar/resources/firebase_provider.dart';

class Repository {
  final _firebaseProvider = FirebaseProvider();

  Future<void> addDataToDb(FirebaseUser user) =>
      _firebaseProvider.addDataToDb(user);

  Future<FirebaseUser> signIn() => _firebaseProvider.signIn();

  Future<bool> authenticateUser(FirebaseUser user) =>
      _firebaseProvider.authenticateUser(user);

  Future<void> signOut() => _firebaseProvider.signOut();

  Future<String> uploadImageToStorage(File imageFile) =>
      _firebaseProvider.uploadImageToStorage(imageFile);

  Future<List<DocumentSnapshot>> fetchStats({String uid, String label}) =>
      _firebaseProvider.fetchStats(uid: uid, label: label);

  Future<void> updatePhoto(String photoUrl, String uid) =>
      _firebaseProvider.updatePhoto(photoUrl, uid);

  Future<void> updateDetails(
          String uid, String name, String bio, String email, String phone) =>
      _firebaseProvider.updateDetails(uid, name, bio, email, phone);

  //Future<List<DocumentSnapshot>> retrievePostByUID(String uid) => _firebaseProvider.retrievePostByUID(uid);

}
