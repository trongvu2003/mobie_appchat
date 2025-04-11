import 'dart:io';

import 'package:app_chat/helper/dialogs.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';


import '../api/api.dart';
import '../helper/my_date_until.dart';
import '../main.dart';
import '../models/chat_user.dart';


class ViewProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ViewProfileScreen({super.key, required this.user});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreen();
}

class _ViewProfileScreen extends State<ViewProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(
            title: Text(widget.user.name),
          ),
          //user about
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Tham gia: ',
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
              ),
              Text(
                  MyDateUtil.getLastMessageTime(
                      context: context,
                      time: widget.user.createAt,
                    showYear: true,
                   ),
                  style: const TextStyle(color: Colors.black54, fontSize: 15)),
            ],
          ),
          body:
          Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
            child: SingleChildScrollView(
              child: Column(children: [
                SizedBox(width: mq.width, height: mq.height * .03,),
                ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * .1),
                  child: CachedNetworkImage(
                    height: mq.height * .2,
                    width: mq.height * .2,
                    fit: BoxFit.fill,
                    imageUrl: widget.user.images,
                    //placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget:
                        (context, url, error) =>
                    const CircleAvatar(child: Icon(CupertinoIcons.person)),
                  ),
                ),
                SizedBox(height: mq.height * .03),
                Text(widget.user.email,
                    style:
                    const TextStyle(color: Colors.black87, fontSize: 16)),

                // for adding some space
                SizedBox(height: mq.height * .02),

                //user about
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'About: ',
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                          fontSize: 15),
                    ),
                    Text(widget.user.about,
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 15)),
                  ],
                ),
              ],
              ),
            ),
          )),
    );
  }
}