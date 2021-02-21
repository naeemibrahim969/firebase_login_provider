import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';


@immutable
class LoggedInUser {
  const LoggedInUser({@required this.user});
  final User user;
}

class FirebaseAuthService {
  final _firebaseAuth = FirebaseAuth.instance;

  LoggedInUser _userFromFirebase(User user) {
    return user == null ? null : LoggedInUser(user: user);
  }

  Future<LoggedInUser> createUser(String firstName,String lastName,String email, String password,String phone,String address,String gender,String dob,String image) async {
    UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(userCredential.user);
  }

  Future<LoggedInUser> signInWithEmailAndPassword(String email, String password) async {
    UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(userCredential.user);
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}