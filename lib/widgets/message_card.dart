import 'package:app_chat/helper/my_date_until.dart';
import 'package:app_chat/models/message.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../api/api.dart';
import '../main.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});

  final Message message;
  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid ==widget.message.fromId ?_greenMessage(): _blueMessage();
  }
  // tn nhắn từ người khác
  Widget _blueMessage(){
    // cập nhật lần đọc tn cuối nếu gửi và nhận # nhau
    if (widget.message.read.isEmpty){
      APIs.updateMessageReadStatus(widget.message);
      print('Tin nhắn đọc đã được cập nhật');
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.blue.shade50,
                border: Border.all(color: Colors.blue),
                borderRadius:BorderRadius.only(topLeft: Radius.circular(30),
            topRight: Radius.circular(30),bottomRight: Radius.circular(30)
            ) ),
            padding: EdgeInsets.all(mq.width * .04),
            margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: mq.height * .01),
            child:
            widget.message.type == Type.text
                ?
            Text(widget.message.msg , style: TextStyle(fontSize: 15, color: Colors.black),
            ):ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: CachedNetworkImage(
                imageUrl: widget.message.msg,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(strokeWidth: 2),
                ),
                errorWidget: (context, url, error) =>
                const Icon(Icons.image, size: 70),
                ),
                ),
                ),

        ),
        Padding(
          padding: EdgeInsets.only(right: mq.width * .04),
          child: widget.message.type == Type.text
              ?
          Text(widget.message.msg , style: TextStyle(fontSize: 15, color: Colors.black),
          ):ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            child: CachedNetworkImage(
              imageUrl: widget.message.msg,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              errorWidget: (context, url, error) =>
              const Icon(Icons.image, size: 70),
            ),
          ),
        ),
      ],
    );
  }
  // tin nhắn từ mình
  Widget _greenMessage(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
          Row(
            children: [
              SizedBox(width: mq.width * .04,),
              if (widget.message.read.isNotEmpty)
              Icon(Icons.done_all_rounded,color: Colors.blue,size: 20,),
              //thoi gian gửi tn
              Text(MyDateUtil.getFormattesTime(context: context, time: widget.message.sent),
                style: TextStyle(fontSize: 13,color: Colors.black45),),
              SizedBox(width: 2,)
            ],
          ),

        Flexible(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.lightGreen.shade200,
                border: Border.all(color: Colors.lightGreen),
                borderRadius:BorderRadius.only(topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),bottomLeft: Radius.circular(30)
                ) ),
            padding: EdgeInsets.all(mq.width * .04),
            margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: mq.height * .01),
            child: Text(widget.message.msg , style: TextStyle(fontSize: 15, color: Colors.black),),
          ),
        ),
      ],
    );
  }
}
