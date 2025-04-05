import 'package:app_chat/helper/dialogs.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';


import '../api/api.dart';
import '../main.dart';
import '../models/chat_user.dart';
import 'auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin người dùng'),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.redAccent,
            onPressed: () async {
              Dialogs.showProgressbar(context);
              await APIs.auth.signOut().then((value) async {
                await GoogleSignIn().signOut().then((value){
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>LoginScreen()));
                });
              });
              
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            icon: const Icon(Icons.logout), label: Text('Đăng xuất', style: TextStyle(fontWeight: FontWeight.bold),),
          ),),
      body:
        Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
          child: Column(children: [
          SizedBox(width: mq.width,height: mq.height *.03,),
             Stack(
                children: [
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
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: MaterialButton(
                      color: Colors.white,
                      elevation: 1,
                      shape: CircleBorder(),
                      onPressed: (){},child: Icon(Icons.edit,color: Colors.blue,),),
                  ),
                ],
              ),
            SizedBox(height: mq.height *.03),
            Text(widget.user.email, style: TextStyle(color: Colors.black,fontSize: 17),),
            SizedBox(height: mq.height *.05),
            TextFormField(
              initialValue: widget.user.name,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person, color: Colors.blue,),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(13)),
                  hintText:'Name',
                  label: Text('Tên đăng nhập')
              ),
            ),
            SizedBox(height: mq.height *.02),
            TextFormField(
              initialValue: widget.user.about,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.info_outline,color: Colors.blue),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(13)),
                  hintText:'Vui vẻ',
                  label: Text('About')
              ),
            ),
            SizedBox(height: mq.height *.05),
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade100,
                    shape:StadiumBorder(),
                  minimumSize: Size(mq.width * .5, mq.height * .06)
                ),
                onPressed: (){},
                icon: Icon(Icons.edit, size: 25,), label: Text('Cập nhật', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),
          ],
          ),
        )
    );
  }
}
