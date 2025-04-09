import 'dart:io';

import 'package:app_chat/helper/dialogs.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';


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
  final _formKey =GlobalKey<FormState>();
  String? _image;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: Scaffold(
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
          Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
              child: SingleChildScrollView(
                child: Column(children: [
                SizedBox(width: mq.width,height: mq.height *.03,),
                   Stack(
                      children: [
                        // image prifile
                        _image != null ?
                       ClipRRect(
                       borderRadius: BorderRadius.circular(mq.height * .1),
                        child: Image.file(
                          File(_image!),
                          height: mq.height * .2,
                          width: mq.height * .2,
                          fit: BoxFit.cover,
                        ),
                      )
                    :
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
                        // nút edit
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: MaterialButton(
                            color: Colors.white,
                            elevation: 1,
                            shape: CircleBorder(),
                            onPressed: (){
                              _showBottomSheet();
                            },child: Icon(Icons.edit,color: Colors.blue,),),
                        ),
                      ],
                    ),
                  SizedBox(height: mq.height *.03),
                  Text(widget.user.email, style: TextStyle(color: Colors.black,fontSize: 17),),
                  SizedBox(height: mq.height *.05),
                  TextFormField(
                    initialValue: widget.user.name,
                    onSaved:(val)=>APIs.me.name = val ?? '',
                    validator: (val)=> val != null && val.isNotEmpty ? null:'Tên không được trống',
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
                    onSaved:(val)=>APIs.me.about = val ?? '',
                    validator: (val)=> val != null && val.isNotEmpty ? null:'Thông tin không được trống',
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
                      onPressed: (){
                        if(_formKey.currentState!.validate()){
                          _formKey.currentState!.save();
                          APIs.updateUserInfo().then((value){
                            Dialogs.showSnackbar(context, 'Cập nhật thông tin thành công');
                            }
                          );
                        }
                      },
                      icon: Icon(Icons.edit, size: 25,), label: Text('Cập nhật', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),
                ],
                ),
              ),
            ),
          )
      ),
    );
  }
  // chọn ảnh profile
  void _showBottomSheet() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(borderRadius:
      BorderRadius.only
        (topLeft: Radius.circular(20),
          topRight: Radius.circular(20))),
      context: context,
      builder: (_) {
        return ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(top: mq.height * .03,bottom: mq.height * .05),
          children: [
            const Text('Chọn hình ảnh',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
            SizedBox(height: mq.height * .02,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                    if (image != null){
                      print('Image path: ${image.path} --Mimetype: ${image.mimeType}');
                      Navigator.pop(context);
                      setState(() {
                        _image=image.path;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    backgroundColor:  Colors.white,
                    fixedSize: Size(mq.width * .3, mq.height * .15)
                  ),
                  child: Image.asset('images/add_image.jpg', ), // Sửa lại tên file
                ),
                ElevatedButton(
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(source: ImageSource.camera);
                    if (image != null){
                      print('Image path: ${image.path}');
                      Navigator.pop(context);
                      setState(() {
                        _image=image.path;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      backgroundColor:  Colors.white,
                      fixedSize: Size(mq.width * .3, mq.height * .15)
                  ),
                  child: Image.asset('images/camera.png', width: 100,height: 100,), // Sửa lại tên file
                ),
              ],
            ),

          ],
        );
      },
    );
  }
}
