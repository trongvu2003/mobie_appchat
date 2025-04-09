import 'dart:convert';

import 'package:app_chat/screens/auth/login_screen.dart';
import 'package:app_chat/screens/profile_screen.dart';
import 'package:app_chat/widgets/chat_user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:app_chat/main.dart';

import '../api/api.dart';
import '../models/chat_user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  List<ChatUser> _list=[];
  final List<ChatUser> _searchList=[];
  bool _isSearching =false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> Focus.of(context).unfocus(),
      //nếu tìm kiếm đc bật & nútback được nhấn thì đóng search
      // Ví dụ quay về màn hình nếu từ home nhấn quay về
      child: WillPopScope(
        onWillPop: (){
          if(_isSearching){
            setState(() {
              _isSearching= !_isSearching;
            });
            return Future.value(false);
          }else{return Future.value(true);}
        },
        child: Scaffold(
          appBar: AppBar(
            leading: Icon(CupertinoIcons.home),
            title: _isSearching? TextField(
              decoration: const InputDecoration(
                border: InputBorder.none, hintText: 'Tên, Email,....',
              ),
              style: TextStyle(fontSize: 19, letterSpacing: 0.5),
              autofocus: true,
              //Khi tim kiem thi update lai list;
              onChanged: (val){
                // logic search
                _searchList.clear();

                for (var i in _list){
                  if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                      i.email.toLowerCase().contains(val.toLowerCase())){
                        _searchList.add(i);
                  }
                  setState(() {
                    _searchList;
                  });
                }
              },
            ) : Text('Chatting'),
            actions: [
              IconButton(onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                });
              }, icon: Icon(_isSearching ? CupertinoIcons.clear_circled_solid : Icons.search)),
              IconButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_)=> ProfileScreen(user: APIs.me)));
              }, icon: Icon(Icons.more_vert)),
            ],
          ),
          body: StreamBuilder(
            stream: APIs.getAllUsers(),
            builder: (context,snapshot){

              switch (snapshot.connectionState)
              {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(child: CircularProgressIndicator());
                case ConnectionState.active:
                case ConnectionState.done:


                if(snapshot.hasData){
                  final data =snapshot.data?.docs;
                  _list =data?.map((e)=> ChatUser.fromJson(e.data())).toList() ?? [];
                }
               if (_list.isNotEmpty){
                 return ListView.builder(
                     itemCount: _isSearching?_searchList.length : _list.length,
                     padding: EdgeInsets.only(top:mq.height * .01),
                     physics: BouncingScrollPhysics(),
                     itemBuilder: (context, index)
                     {
                       // return Text('name:${list[index]}');
                       return ChatUserCard(user:_isSearching ?_searchList[index] : _list[index]);
                     }
                 );
               }else{
                return Center(child: Text('Không có người dùng nào !',style: TextStyle(fontSize: 20),));
               }
              }
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
        ),
      ),
    );
  }
}
