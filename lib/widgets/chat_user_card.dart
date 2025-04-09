import 'package:app_chat/models/chat_user.dart';
import 'package:app_chat/screens/chat_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_)=> ChatScreen(user: widget.user,)));
        },
        child: ListTile(
          //leading: const CircleAvatar(child: Icon(CupertinoIcons.person),),
          leading: ClipRRect(
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
          title: Text(widget.user.name),
          subtitle: Text(widget.user.about, maxLines: 1),
          //trailing: Text('12:00 PM', style: TextStyle(color: Colors.black54)),
          trailing: Container(width: 15,height: 15,
              decoration: BoxDecoration(color: Colors.greenAccent.shade400, borderRadius: BorderRadius.circular(10)),)
        ),
      ),
    );
  }
}
