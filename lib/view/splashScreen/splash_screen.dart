import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sellers/view/authscreens/auth_screen.dart';
import 'package:sellers/view/mainscreen/home_screen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});
  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  initTimer(){
    Timer(const Duration(seconds: 5),() async
    {
      if( FirebaseAuth.instance.currentUser == null){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (c)=>const AuthScreen()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (c)=>const HomeScreen()));
      }
    });
  }

  @override
  void initState(){
    super.initState();
    initTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Lottie.network("https://lottie.host/8825a28c-5940-4a79-ac2a-b5fd7f2067bf/fNVxBpZTH1.json",
              width: MediaQuery.of(context).size.width,
              height: 500)
            ),
            const Text(
              "Green Stack",
              textAlign: TextAlign.center,
              style: TextStyle(
                letterSpacing: 3,
                fontSize: 26,
                color: Colors.green,
                fontWeight: FontWeight.bold
              ),
            )
          ],
        ),
      ),
    );
  }
}
