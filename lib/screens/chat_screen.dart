import 'dart:convert';

import 'package:app_chat/models/chat_user.dart';
import 'package:app_chat/widgets/message_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../api/api.dart';
import '../main.dart';
import '../models/message.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> _list=[];

  final _textController= TextEditingController();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    return Scaffold(
      backgroundColor: Colors.greenAccent.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        title: _appBar(),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: APIs.getAllMessages(widget.user),
              builder: (context,snapshot){

                switch (snapshot.connectionState)
                {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                     return SizedBox();
                  case ConnectionState.active:
                  case ConnectionState.done:
                      final data =snapshot.data?.docs;
                      _list =data?.map((e)=> Message.fromJson(e.data())).toList() ?? [];
                    }

                    if (_list.isNotEmpty){
                      return ListView.builder(
                          itemCount: _list.length,
                          padding: EdgeInsets.only(top:mq.height * .01),
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index)
                          {
                            return MessageCard( message: _list[index]);
                          }
                      );
                    }else{
                      return Center(child: Text('Say hi !!! 👋',style: TextStyle(fontSize: 20),));
                    }
                }
            ),
          ),
          _chatInput()
        ],
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * .3),
            child: CachedNetworkImage(
              height: mq.height * .05,
              width: mq.height * .05,
              imageUrl: widget.user.images,
              //placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget:
                  (context, url, error) =>
                      const CircleAvatar(child: Icon(CupertinoIcons.person)),
            ),
          ),
          SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user.name,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 1),
              Text(
                'Không hoạt động',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: mq.height * .01, horizontal: mq.width * .025),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.emoji_emotions),
                      color: Colors.blue,
                        iconSize: 26
                    ),
                    Expanded(child: TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(hintText: 'Nhập nội dung...',
                          hintStyle: TextStyle(color: Colors.blueAccent),
                          border: InputBorder.none,
                      ),
                    )),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.image),
                      color: Colors.blue,iconSize: 26,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.camera_alt_rounded),
                      color: Colors.blue,iconSize: 26,
                    ),
                    SizedBox(width: mq.width * .02,)
                  ],
              ),
            ),
          ),
          MaterialButton(onPressed: (){
            if(_textController.text.isNotEmpty){
              APIs.sendMessage(widget.user,_textController.text);
              _textController.text='';
            }
          },
            shape: CircleBorder(),
            minWidth: 0,
            color:Colors.green,
            padding: EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            child: Icon(Icons.send,color: Colors.white,size: 26,),)
        ],
      ),
    );
  }
}


