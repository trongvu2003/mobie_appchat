import 'package:app_chat/api/api.dart';
import 'package:app_chat/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_chat/main.dart';
import 'package:flutter/services.dart';
import 'package:app_chat/main.dart';

import 'auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds:2), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
      if(APIs.auth.currentUser != null){
        print('\nUser: ${APIs.auth.currentUser?.displayName}');
        print('\nUserAdditionalInfo: ${APIs.auth.currentUser?.toString()}');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const HomeScreen()));
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(

      body: Stack(
        children: [
         Positioned(
            top: mq.height * .15,
            right: mq.width * .25 ,
            width: mq.width * .5,
            child: Image.asset('images/icon.png'),
          ),
          Positioned(
            bottom: mq.height * .15,
            left: mq.width * .05,
            width: mq.width * .9,
            child: const Text('MADE IN GROUP 3 WITH LOVE ❤️',
              textAlign:TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black87),)
          ),
        ],
      ),
    );
  }
}
