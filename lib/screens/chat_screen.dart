import 'dart:convert';
import 'dart:io';
import 'package:app_chat/screens/view_profile_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:app_chat/models/chat_user.dart';
import 'package:app_chat/widgets/message_card.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';


import 'package:flutter/services.dart';import 'package:image_picker/image_picker.dart';

import '../api/api.dart';
import '../helper/my_date_until.dart';
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

  bool _showEmoji =false, _isUploading= false;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: (){
          if(_showEmoji){
            setState(() {
              _showEmoji= !_showEmoji;
            });
            return Future.value(false);
          }else{return Future.value(true);}
        },
        child: Scaffold(
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
                            reverse: true,
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
              _chatInput(),
              if(_isUploading)
              Align(
                alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  )),
        
              if(_showEmoji)
                SizedBox(
                  height: mq.height * 0.36,
                  child: EmojiPicker(
                    textEditingController: _textController,
                    config: Config(
                      emojiViewConfig: EmojiViewConfig(
                        emojiSizeMax: 28 *
                            (foundation.defaultTargetPlatform == TargetPlatform.iOS ? 1.2 : 1.0),
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ViewProfileScreen(user: widget.user)));
      },
      child:StreamBuilder(stream: APIs.getUserInfo(widget.user),
          builder: (context, snapshot){
    final data =snapshot.data?.docs;
    final list =data?.map((e)=>ChatUser.fromJson(e.data())).toList() ?? [];
        return  Row(
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
                imageUrl: _list.isNotEmpty? list[0].images : widget.user.images,
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
                Text(_list.isNotEmpty ? list[0].name:
                  widget.user.name,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 1),
                Text(
                    list.isNotEmpty
                        ? list[0].isOnline
                        ? 'Online'
                        : MyDateUtil.getLastActiveTime(
                        context: context,
                        lastActive: list[0].lastActive)
                        : MyDateUtil.getLastActiveTime(
                        context: context,
                        lastActive: widget.user.lastActive),
                    style: const TextStyle(
                        fontSize: 13, color: Colors.black54)),
              ],
            ),
          ],
        );
    })
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
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        setState(()=> _showEmoji = !_showEmoji );},
                      icon: Icon(Icons.emoji_emotions),
                      color: Colors.blue,
                        iconSize: 26
                    ),
                    Expanded(child: TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      onTap: (){
                        if(_showEmoji)
                        setState(()=> _showEmoji = !_showEmoji );
                      },
                      maxLines: null,
                      decoration: const InputDecoration(hintText: 'Nhập nội dung...',
                          hintStyle: TextStyle(color: Colors.blueAccent),
                          border: InputBorder.none,
                      ),
                    )),
                    IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Picking multiple images
                        final List<XFile> images =
                        await picker.pickMultiImage(imageQuality: 70);

                        // uploading & sending image one by one
                        for (var i in images) {
                          print('Image Path: ${i.path}');
                          setState(() => _isUploading = true);
                          await APIs.sendChatImage(widget.user, File(i.path));
                          setState(() => _isUploading = false);
                        }
                      },
                      icon: Icon(Icons.image),
                      color: Colors.blue,iconSize: 26,
                    ),
                    IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image = await picker.pickImage(source: ImageSource.camera,imageQuality: 70);
                        if (image != null){
                          print('Image path: ${image.path}');
                          await APIs.sendChatImage(widget.user, File(image.path));
                        }
                      },
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
              APIs.sendMessage(widget.user,_textController.text,Type.text);
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


