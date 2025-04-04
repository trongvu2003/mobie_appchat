import 'package:app_chat/models/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_chat/main.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCard();
}

class _ChatUserCard extends State<ChatUserCard> {
    @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: 4),
      // color: Colors.blue.shade100,
        elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), child: InkWell(
      onTap:(){},
      child: ListTile(
        leading: const CircleAvatar(child: Icon(CupertinoIcons.person),),
        title: Text(widget.user.name),
        subtitle: Text(widget.user.about, maxLines: 1,),
        trailing: Text('12:00 PM', style: TextStyle(color:Colors.black54),),
      ),
    ));
  }
}