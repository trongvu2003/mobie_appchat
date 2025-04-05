import 'package:app_chat/models/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static User get user => auth.currentUser!;


  static late ChatUser me;
  // kiem tra nguoi dung co ton tai k
  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user?.uid).get()).exists;
  }

  static Future<void> getSelfInfo() async {
   await firestore.collection('users').doc(user?.uid).get().then((user) async {
      if(user.exists){
        me= ChatUser.fromJson(user.data()!);
        print('My data: ${user.data()}');
      }else{
        await createUser().then((value)=>getSelfInfo());
      }
   });
  }

  // tao 1 user mới
  static Future<bool> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = ChatUser(
      id: user!.uid,
      name: user!.displayName.toString(),
      email: user.email.toString(),
      about: 'Hello, i\'m Vu',
      images: user.photoURL.toString(),
      createAt: time,
      isOnline: false,
      lastActive: time,
      pushToken: '',
    );
    await firestore.collection('users').doc(user.uid).set(chatUser.toJson());
    return true;
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }
}
