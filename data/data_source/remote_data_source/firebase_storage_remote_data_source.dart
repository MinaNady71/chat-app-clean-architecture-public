import 'dart:io';

import 'package:chat_app/app/constants.dart';
import 'package:chat_app/data/data_source/remote_data_source/firebase_constant.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

abstract class FirebaseStorageDatasource {
  Future<String> uploadImage(File imageFile);
}

class FirebaseStorageDatasourceImpl implements FirebaseStorageDatasource {

  final _storage = FirebaseStorage.instance;

  @override
  Future<String> uploadImage(imageFile)async {
    String path ='${FirebaseConstants.usersStorage}/${FirebaseConstants.imagesStorage}/${Constants.storageImage+UniqueKey().hashCode.toString()}';
    var response =  await _storage.ref(path).putFile(imageFile);
    return await response.ref.getDownloadURL();
  }

}
