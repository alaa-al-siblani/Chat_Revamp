import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

class User {
  //for notifications
  // static Future<void> _onBackgroundMessage(RemoteMessage message) async {
  //   print(message.notification!.body);
  // }

  // static Future<void> initNotifications() async {
  //   var fbm = FirebaseMessaging.instance;
  //   await fbm.requestPermission();
  //   final token = await FirebaseMessaging.instance.getToken();
  //   print(token);
  //   FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);
  // }

  static void addUser(String name, String email, String? imageUrl) {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    if (imageUrl == null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set({'username': name, 'email': email});
      return;
    }
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set({'username': name, 'email': email, 'imageUrl': imageUrl});
  }

  static Future<String> saveImage(File image) async {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    var ref = FirebaseStorage.instance.ref('images/$uid');
    await ref.putFile(image);
    return await ref.getDownloadURL();
  }
}
