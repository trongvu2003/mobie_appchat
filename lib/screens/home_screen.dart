import 'package:app_chat/screens/auth/login_screen.dart';
import 'package:app_chat/widgets/chat_user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:app_chat/main.dart';

import '../api/api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(CupertinoIcons.home),
        title: const Text('Chatting'),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        ],
      ),
      body: StreamBuilder(
        stream: APIs.firestore.collection('users').snapshots(),
        builder: (context,snapshot){
          final list=[];
          if(snapshot.hasData){
            final data =snapshot.data?.docs;
            for (var i in data!){
              print('Data:${i.data()}');
              list.add(i.data()['name']);
            }
          }
          return ListView.builder(
              itemCount: list.length,
              padding: EdgeInsets.only(top:mq.height * .01),
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index)
              {
                return Text('name:${list[index]}');
                // return const ChatUserCard();
              }
          );
      },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: () async {
            await APIs.auth.signOut();
            await GoogleSignIn().signOut();
            Navigator.push(context, MaterialPageRoute(builder: (_)=>LoginScreen()));
          },
          child: Icon(Icons.add_comment_rounded),
        ),
      ),
    );
  }
}
