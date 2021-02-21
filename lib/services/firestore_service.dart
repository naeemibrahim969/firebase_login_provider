
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService{

  Future<void> saveUser(String firstName,String lastName,String email, String password,String phone,String address,String gender,String dob,String image) async {

    final reference = FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser.uid);
    await reference.set({
      'FirstName':firstName,
      'LastName':lastName,
      'Phone':phone,
      'Address':address,
      'gender':gender,
      'DOB':dob,
      'Pic':image,
    });
  }

}