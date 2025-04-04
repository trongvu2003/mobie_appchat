import 'package:app_chat/models/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class APIs{
  static FirebaseAuth auth =FirebaseAuth.instance;
  static FirebaseFirestore firestore =FirebaseFirestore.instance;
  static User get user => auth.currentUser!;
  // kiem tra nguoi dung co ton tai k
  static Future<bool> userExists() async{
    return (await firestore.collection('users').doc(user?.uid).get()).exists;
  }
  // tao 1 user mới
  static Future<bool> createUser() async{
    final time =DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = ChatUser(id: user!.uid,
      name: user!.displayName.toString(),
      email: user.email.toString(),
      about:'Hello, i\'m Vu',
      images: user.photoURL.toString(),
      createAt: time,
      isOnline:false,
      lastActive:time,
      pushToken:'',
    );
    await firestore.collection('users').doc(user.uid).set(chatUser.toJson());
    return true;
  }
}