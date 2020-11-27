import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wild_boar/screens/FeedScreen.dart';
import 'package:wild_boar/screens/LoginScreen.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  // ignore: deprecated_member_use
  static final _firestore = Firestore.instance;

  static void signUpUser(
      BuildContext context, String name, String email, String password) async {
    try {
      UserCredential authResult = (await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      )) as UserCredential;
      FirebaseUser signedInUser = authResult.user as FirebaseUser;
      if (signedInUser != null) {
        _firestore.collection('/users').document(signedInUser.uid).setData({
          'bio': '',
          'displayName': name,
          'email': email,
          'phone': '',
          'photoUrl': '',
          'posts': '',
          'uid': signedInUser.uid,
        });
        Navigator.pushReplacementNamed(context, FeedScreen.id);
      }
    } catch (e) {
      print(e);
    }
  }

  static void logout(BuildContext context) {
    _auth.signOut();

    Navigator.popAndPushNamed(context, LoginPage.id);
  }

  static void login(BuildContext context, String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacementNamed(context, FeedScreen.id);
    } catch (e) {
      print(e);
    }
  }
}

class AuthResult {}
