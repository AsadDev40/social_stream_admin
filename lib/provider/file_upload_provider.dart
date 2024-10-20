import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FileUploadProvider extends ChangeNotifier {
  final _storageRef = FirebaseStorage.instance.ref();

  Future<String?> fileUpload({
    required File file,
    required String fileName,
    required String folder,
  }) async {
    try {
      final uploadTask = _storageRef.child('$folder/$fileName').putFile(file);
      final snapshot = await uploadTask.whenComplete(() => null);
      final imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      return null;
    }
  }

  Future<String?> updateFile({
    required File file,
    required String oldImageUrl,
    required String folder,
    required String name,
  }) async {
    try {
      String fileName = name;
      final oldFileRef = _storageRef.child('$folder/$fileName');

      // Delete the old file if it exist
      await oldFileRef.delete().catchError((error) {});

      // Upload the new file
      final uploadTask = _storageRef.child('$folder/$fileName').putFile(file);
      final snapshot = await uploadTask.whenComplete(() => null);
      final newImageUrl = await snapshot.ref.getDownloadURL();
      return newImageUrl;
    } catch (e) {
      return null;
    }
  }
}
