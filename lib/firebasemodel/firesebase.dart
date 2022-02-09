import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';

class Databse {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String downloadurl = '';
  firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;
  initiliase() {
    _firestore = FirebaseFirestore.instance;
  }

  final User? user = FirebaseAuth.instance.currentUser;

  Future<void> uploadfile(File file, String name, String director) async {
    try {
      CircularProgressIndicator();
      await _storage
          .ref('test/${user!.uid}')
          .child('images${user!.uid + name}')
          .putFile(file);
      downloadurl = await _storage
          .ref('test/${user!.uid}')
          .child('images${user!.uid + name}')
          .getDownloadURL();
      if (downloadurl.length==0) {
      } else {
        print(downloadurl);
        addmovie(name, director, downloadurl);

      }
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }

  Future<List> read() async {
    List docs = [];
    QuerySnapshot querySnapshot;
    try {
      querySnapshot = await _firestore
          .collection('movies')
          .doc(user!.uid)
          .collection('moviedetail')
          .orderBy('timestamp')
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map a = {
            "id": doc.id,
            "director": doc['director'],
            "name": doc['name'],
            "url": doc['url'],
          };
          docs.add(a);
        }
        return docs;
      }
    } catch (e) {
      print(e);
    }
    return docs;
  }

  void update(
    String id,
    String name,
    String director,
  ) async {
    try {
      await _firestore
          .collection('movies')
          .doc(user!.uid)
          .collection('moviedetail')
          .doc(id)
          .update({
        'name': name,
        'director': director,
      });
    } catch (e) {
      print(e);
    }
  }

  void addmovie(String name, String director, String url) async {
    try {
      await _firestore
          .collection('movies')
          .doc(user!.uid)
          .collection('moviedetail')
          .add({
        'name': name,
        'director': director,
        'timestamp': FieldValue.serverTimestamp(),
        'url': url
      });
    } catch (e) {
      print(e);
    }
  }

  void delete(id) async {
    try {
      await _firestore
          .collection('movies')
          .doc(user!.uid)
          .collection('moviedetail')
          .doc(id)
          .delete();
    } catch (e) {
      print(e);
    }
  }
}
