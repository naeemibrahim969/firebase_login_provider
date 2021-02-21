import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/app/auth/register_screen.dart';
import 'package:task/app/home/home_screen.dart';
import 'package:task/services/firebase_auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final formKey = GlobalKey<FormState>();

  String _email;
  String _password;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Task"),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: buildInputs() + loginButton()
          ),
        ),
      ),
    );
  }

  List<Widget> buildInputs() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Email'),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Password'),
        obscureText: true,
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value,
      ),
    ];
  }

  List<Widget> loginButton() {
    return [
      Container(
        margin: EdgeInsets.only(top: 10),
        child: ElevatedButton(
          onPressed: () {
            if (validateAndSave()) {
              try {
                final auth = Provider.of<FirebaseAuthService>(context, listen: false);
                auth.signInWithEmailAndPassword(_email, _password).then((value) => {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen(),),)
                });
              } catch (error) {
                print("Error: $error");
              }
            }
          },
          child: Padding(padding: EdgeInsets.only(top: 10,bottom: 10),child: Text('Login', style: TextStyle(fontSize: 20.0),)),
        ),
      ),
      TextButton(
          onPressed: (){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => RegisterScreen(),),);
          },
          child: Text('Create an account', style: TextStyle(fontSize: 20.0))
      )
    ];
  }
}
