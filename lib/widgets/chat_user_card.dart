import 'package:app_chat/api/api.dart';
import 'package:app_chat/helper/my_date_until.dart';
import 'package:app_chat/models/chat_user.dart';
import 'package:app_chat/models/message.dart';
import 'package:app_chat/screens/chat_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_chat/main.dart';

import 'dialogs/profile_dialog.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCard();
}

class _ChatUserCard extends State<ChatUserCard> {
  // thông tin TN cuối cùng (nếu NULL => no TN)
  Message? _message;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: 4),
      // color: Colors.blue.shade100,
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_)=> ChatScreen(user: widget.user,)));
        },
        child: StreamBuilder(
            stream: APIs.getLastMessage(widget.user),
            builder: (context, snapshot){
              final data =snapshot.data?.docs;
              final list =data?.map((e)=> Message.fromJson(e.data())).toList() ?? [];
            if(list.isNotEmpty){
              _message=list[0];
            }

              return ListTile(
            //leading: const CircleAvatar(child: Icon(CupertinoIcons.person),),
              leading: InkWell(
                onTap: (){
                  showDialog(context: context, builder: (_)=> ProfileDialog(user: widget.user,));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * .3),
                  child: CachedNetworkImage(
                    height: mq.height * .055,
                    width: mq.height * .055,
                    imageUrl: widget.user.images,
                    //placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget:
                        (context, url, error) =>
                    const CircleAvatar(child: Icon(CupertinoIcons.person)),
                  ),
                ),
              ),
              title: Text(widget.user.name),

              // tn cuối cùng
              subtitle: Text( _message != null
                  ? _message!.type == Type.image
                  ? 'image'
                  : _message!.msg
                  : widget.user.about,
                  maxLines: 1),
              //thời gian tn cuối cùng
                trailing: _message != null
                    ? (_message!.read.isEmpty && _message!.fromId != APIs.user.uid
                    ? Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    color: Colors.greenAccent.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                )
                    : Text(
                  MyDateUtil.getLastMessageTime(context: context, time: _message!.sent),
                  style: TextStyle(color: Colors.black54),
                )
                )
                    : null,
              );
        })
      ),
    );
  }
}
