import 'dart:io';

import 'package:app_chat/models/chat_user.dart';
import 'package:app_chat/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static User get user => auth.currentUser!;


  static late ChatUser me;

  static get storage => null;
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
  static Future<void> updateUserInfo() async {
    await firestore.collection('users').doc(user?.uid).update({'name':me.name, 'about': me.about});
  }
  // lấy thông tin id dễ dàng
  static String getConversationID(String id)=> user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      :'${id}_${user.uid}';
  // Chatscreen API
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(ChatUser user) {
    return firestore
        .collection('chat/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }
  // Gửi tin nhắn
  static Future<void> sendMessage(ChatUser chatUser,String msg, Type type) async{
      // thời gian gui tin nhắn
      final time =DateTime.now().millisecondsSinceEpoch.toString();
      // gui tn
      final Message message =Message(toId: chatUser.id, msg: msg, read: '', type: type, fromId: user.uid, sent: time);
      final rel = firestore.collection('chat/${getConversationID(chatUser.id)}/messages/');
      await rel.doc(time).set(message.toJson());
  }

  // Cập nhật trạng thái đọc tn
  static Future<void> updateMessageReadStatus(Message message) async{
    firestore.collection('chat/${getConversationID(message.fromId)}/messages/').doc(message.sent).update({'read':DateTime.now().millisecondsSinceEpoch.toString()});
  }
  //Tin nhắn cuối cùng
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(ChatUser user) {
    return firestore
        .collection('chat/${getConversationID(user.id)}/messages')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }


  static Future<void> sendChatImage(ChatUser chatUser, File file) async {
    final ext = file.path.split('.').last;

    final ref = storage.ref().child(
        'images/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      print('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, imageUrl, Type.image);
  }


  // thông tin user
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      ChatUser chatUser) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }

  // cập nhật onl hay tg hoạt động cuối cùng user
  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection('users').doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'push_token': me.pushToken,
    });
  }
}
