import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirebaseStorageService{

  final _storage = FirebaseStorage.instance;
  final _downloadURL= StreamController<String>();

  Stream<String> get downloadURL {
    return _downloadURL.stream;
  }

  Future<void> uploadPic({@required File file}) async {

    String fileName = file.path.split('/').last;

    final storageReference = _storage.ref().child("$fileName/");
    final metadata = SettableMetadata(contentType: 'image/png', customMetadata: {'picked-file-path': file.path});

    final uploadTask = storageReference.putFile(file, metadata);

    uploadTask.whenComplete(() async {
      String downloadUrl = await uploadTask.snapshot.ref.getDownloadURL();
       _downloadURL.sink.add(downloadUrl);
    });
  }

}