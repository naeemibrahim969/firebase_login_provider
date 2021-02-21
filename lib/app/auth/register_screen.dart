import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:task/app/auth/login_screen.dart';
import 'package:task/app/home/home_screen.dart';
import 'package:task/common_widgets/avatar_widget.dart';
import 'package:task/services/firebase_storage_service.dart';
import 'package:task/services/firebase_auth_service.dart';
import 'package:task/services/firestore_service.dart';
import 'package:task/services/image_picker_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final formKey = GlobalKey<FormState>();

  String _firstName,_lastName,_email,_password,_phone,_address,_gender,_dob,_pic;

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
        child: Column(
          children: [
            Form(
              key: formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: userImage() +buildInputs() + registerButton()
              ),
            ),
            // StreamBuilder(builder: builder)
          ],
        ),
      ),
    );
  }



  Future<void> _chooseAvatar(BuildContext context) async {
    try {
      final imagePicker =
      Provider.of<ImagePickerService>(context, listen: false);
      final file = await imagePicker.pickImage(source: ImageSource.gallery);
      if (file != null) {

        final storage = Provider.of<FirebaseStorageService>(context, listen: false);
        File _image;
        if (file != null) {
          print('file: ${file.path}');
          _image = File(file.path);
        }
        await storage.uploadPic(file: _image);

        await _image.delete();
      }
    } catch (e) {
      print(e);
    }
  }

  List<Widget> userImage(){
    final _storage = Provider.of<FirebaseStorageService>(context, listen: false);
    return[
      StreamBuilder(
        stream: _storage.downloadURL,
        builder: (context, snapshot){
          _pic = snapshot.data;
          return  AvatarWidget(
            photoUrl: snapshot.data != null ? snapshot.data : "https://cdn.jpegmini.com/user/images/slider_puffin_before_mobile.jpg",
            radius: 50,
            borderColor: Colors.black54,
            borderWidth: 2.0,
            onPressed: () => _chooseAvatar(context),
          );
      }),
    ];
  }

  List<Widget> buildInputs() {
    return [
      TextFormField(
        keyboardType: TextInputType.text,
        decoration: InputDecoration(labelText: 'FirstName'),
        validator: (value) => value.isEmpty ? 'FirstName can\'t be empty' : null,
        onSaved: (value) => _firstName = value,
      ),
      TextFormField(
        keyboardType: TextInputType.text,
        decoration: InputDecoration(labelText: 'LastName'),
        validator: (value) => value.isEmpty ? 'LastName can\'t be empty' : null,
        onSaved: (value) => _lastName = value,
      ),
      TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(labelText: 'Email'),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value,
      ),
      TextFormField(
        obscureText: true,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(labelText: 'Password'),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value,
      ),
      TextFormField(
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(labelText: 'Phone'),
        validator: (value) => value.isEmpty ? 'Phone can\'t be empty' : null,
        onSaved: (value) => _phone = value,
      ),
      TextFormField(
        keyboardType: TextInputType.text,
        decoration: InputDecoration(labelText: 'Address'),
        validator: (value) => value.isEmpty ? 'Address can\'t be empty' : null,
        onSaved: (value) => _address = value,
      ),
      TextFormField(
        keyboardType: TextInputType.text,
        decoration: InputDecoration(labelText: 'Gender'),
        validator: (value) => value.isEmpty ? 'Gender can\'t be empty' : null,
        onSaved: (value) => _gender = value,
      ),
      TextFormField(
        keyboardType: TextInputType.text,
        decoration: InputDecoration(labelText: 'DOB'),
        validator: (value) => value.isEmpty ? 'DOB can\'t be empty' : null,
        onSaved: (value) => _dob = value,
      ),
    ];
  }

  List<Widget> registerButton() {
    return [
      Container(
        margin: EdgeInsets.only(top: 10),
        child: ElevatedButton(
          onPressed: () {
            if (validateAndSave()) {
              try {
                final auth = Provider.of<FirebaseAuthService>(context, listen: false);
                final _db = Provider.of<FirestoreService>(context, listen: false);
                auth.createUser(_firstName,_lastName,_email, _password,_phone,_address,_gender,_dob,_pic).then((value) => {
                  _db.saveUser(_firstName,_lastName,_email, _password,_phone,_address,_gender,_dob,_pic).then((value) => {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen(),),)
                  })
                });
              } catch (error) {
                print("Error: $error");
              }
            }
          },
          child: Padding(padding: EdgeInsets.only(top: 10,bottom: 10), child: Text('Register', style: TextStyle(fontSize: 20.0),)),
        ),
      ),
      TextButton(
          onPressed: (){
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (_) => LoginScreen(),
              ),
            );
          },
          child: Text('Already has an account? Login', style: TextStyle(fontSize: 20.0))
      )
    ];
  }
}
