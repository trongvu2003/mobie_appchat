import 'dart:io';
import 'dart:math';
import 'dart:developer';
import 'package:app_chat/helper/dialogs.dart';
import 'package:app_chat/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app_chat/main.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  bool _isAnimate = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isAnimate = true;
      });
    });
  }

  _handleGoogleBtnClick() {
    Dialogs.showProgressbar(context);
    _signInWithGoogle().then((user) {
      Navigator.pop(context);
      if (user != null) {
        print('\nUser: ${user.user?.displayName}');
        print('\nUserAdditionalInfo: ${user.additionalUserInfo?.toString()}');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    }).catchError((e) {
      print('Error during Google sign-in: $e');
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print('\n_signInWithGoogle: $e');
      Dialogs.showSnackbar(context, 'kiem tra ket noi Internet');
      return null;
    }
  }

  _signOut() async{
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }
  @override
  Widget build(BuildContext context) {
    //mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Welcome to Chatting'),
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
            top: mq.height * .15,
            right: _isAnimate ? mq.width * .25 : mq.width * .5,
            width: mq.width * .5,
            duration: const Duration(seconds: 1),
            child: Image.asset('images/icon.png'),
          ),
          Positioned(
            top: mq.height * .60,
            left: mq.width * .05,
            width: mq.width * .9,
            height: mq.height * .07,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 208, 248, 162),
                shape: const StadiumBorder(),
                elevation: 1,
              ),
              onPressed: () {
                _handleGoogleBtnClick();
              },
              icon: Image.asset('images/google.webp', height: mq.height * .05),
              label: RichText(
                text: const TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  children: [
                    TextSpan(text: 'Login with '),
                    TextSpan(
                      text: 'Google',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
