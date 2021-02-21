import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/app/auth/login_screen.dart';
import 'package:task/services/firebase_auth_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Future<void> _signOut(BuildContext context) async {
    try{
      final auth = Provider.of<FirebaseAuthService>(context,listen: false);
      await auth.signOut();
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen(),),);
    }catch(error){
      print('Error $error');
    }
  }

  @override
  Widget build(BuildContext context) {

    DocumentReference ref = FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser.uid);

    ref.get().then((value) => {
     print(value.data()['Address'])
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          TextButton(
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
    );
  }
}
