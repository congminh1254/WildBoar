import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wild_boar/models/Report.dart';
import 'package:wild_boar/models/user.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class FirebaseProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  Users user;
  Report report;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  StorageReference _storageReference;

  Future<Users> addDataToDb(FirebaseUser currentUser) async {
    print("Inside addDataToDb Method");

    /*_firestore
        .collection("display_names")
        .document(currentUser.displayName)
        .setData({'displayName': currentUser.displayName}); */

    user = Users(
        uid: currentUser.uid,
        email: currentUser.email,
        displayName: currentUser.displayName,
        photoUrl: currentUser.photoUrl,
        bio: '',
        posts: '0',
        phone: '');
    if (user.email == null)
      for (UserInfo info in currentUser.providerData)
        if (info.email != null) user.email = info.email;
    //  Map<String, String> mapdata = Map<String, dynamic>();

    //  mapdata = user.toMap(user);

    await _firestore
        .collection("users")
        .document(currentUser.uid)
        .setData(user.toMap(user));
    return user;
  }

  Future<bool> authenticateUser(FirebaseUser user) async {
    print("Inside authenticateUser");
    final QuerySnapshot result = await _firestore
        .collection("users")
        .where("email", isEqualTo: user.email)
        .getDocuments();

    final List<DocumentSnapshot> docs = result.documents;

    if (docs.length == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    return await _auth.signOut();
  }

  Future<FirebaseUser> signIn() async {
    GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuthentication =
        await _signInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: _signInAuthentication.accessToken,
      idToken: _signInAuthentication.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    return user;
  }

  Future<String> uploadImageToStorage(File imageFile) async {
    _storageReference = FirebaseStorage.instance
        .ref()
        .child('images')
        .child('${DateTime.now().millisecondsSinceEpoch}');
    StorageUploadTask storageUploadTask = _storageReference.putFile(imageFile);
    var url = await (await storageUploadTask.onComplete).ref.getDownloadURL();
    //return url;

    //StorageUploadTask storageUploadTask = _storageReference.putFile(imageFile);
    StorageTaskSnapshot storageSnap = await storageUploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> uploadImageToStorageByData(Uint8List imageFile) async {
    _storageReference = FirebaseStorage.instance
        .ref()
        .child('images')
        .child('${DateTime.now().millisecondsSinceEpoch}');
    StorageUploadTask storageUploadTask = _storageReference.putData(imageFile);
    var url = await (await storageUploadTask.onComplete).ref.getDownloadURL();
    //return url;

    //StorageUploadTask storageUploadTask = _storageReference.putFile(imageFile);
    StorageTaskSnapshot storageSnap = await storageUploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<List<DocumentSnapshot>> fetchStats({String uid, String label}) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection("users")
        .document(uid)
        .collection(label)
        .getDocuments();
    return querySnapshot.documents;
  }

  Future<void> updatePhoto(String photoUrl, String uid) async {
    Map<String, dynamic> map = Map();
    map['photoUrl'] = photoUrl;
    return _firestore.collection("users").document(uid).updateData(map);
  }

  Future<void> updateDetails(String uid, String name, String phone) async {
    Map<String, dynamic> map = Map();
    map['displayName'] = name;
    map['phone'] = phone;
    return _firestore.collection("users").document(uid).updateData(map);
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser;
    currentUser = await _auth.currentUser();
    print("EMAIL ID : ${currentUser.email}");
    return currentUser;
  }

  Future<Users> retrieveUserDetails(FirebaseUser user) async {
    DocumentSnapshot _documentSnapshot =
        await _firestore.collection("users").document(user.uid).get();
    if (_documentSnapshot.data == null) return await addDataToDb(user);
    return Users.fromMap(_documentSnapshot.data);
  }

  Future<void> addReportToDb(
    Users currentUser,
    String coordinate,
    List<Asset> imgMain,
    String status,
    String type,
    String handled,
    String decription,
  ) async {
    List<String> images = new List<String>();
    for (Asset asset in imgMain) {
      ByteData byteData =
          await asset.getByteData(); // requestOriginal is being deprecated
      List<int> imageData = byteData.buffer.asUint8List();
      String url = await uploadImageToStorageByData(imageData);
      images.add(url);
    }
    CollectionReference _collectionRef = _firestore
        .collection("users")
        .document(currentUser.uid)
        .collection("reports");
    report = Report(
        currentUserUid: currentUser.uid,
        images: images,
        coordinate: coordinate,
        status: status,
        type: type,
        handled: handled,
        decription: decription,
        time: FieldValue.serverTimestamp());

    final collRef = Firestore.instance
        .collection("users")
        .document(currentUser.uid)
        .collection("reports");
    DocumentReference docReference = collRef.document();

    docReference.setData(report.toMap(report)).then((doc) {
      print('hop ${docReference.documentID}');
    }).catchError((error) {
      print(error);
    });
    return null;
  }

  Future<Users> fetchUserDetailsById(String uid) async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection("users").document(uid).get();
    return Users.fromMap(documentSnapshot.data);
  }

  Future<List<String>> retrieveUserReport(String userId) async {
    List<String> list = List<String>();
    QuerySnapshot querySnapshot = await _firestore
        .collection("users")
        .document(userId)
        .collection("reports")
        .getDocuments();

    for (int i = 0; i < querySnapshot.documents.length; i++) {
      list.add(querySnapshot.documents[i].documentID.toString());
    }
    return list;
  }

  Future<List<DocumentSnapshot>> fetchReport(FirebaseUser user) async {
    List<DocumentSnapshot> list = List<DocumentSnapshot>();

    QuerySnapshot postSnapshot = await _firestore
        .collection("users")
        .document(user.uid)
        .collection("reports")
        .getDocuments();
    // postSnapshot.documents;
    for (var i = 0; i < postSnapshot.documents.length; i++) {
      print("dad : ${postSnapshot.documents[i].documentID}");
      list.add(postSnapshot.documents[i]);
      print("ads : ${list.length}");
    }

    return list;
  }
}
