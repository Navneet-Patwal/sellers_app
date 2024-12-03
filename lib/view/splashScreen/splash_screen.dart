import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sellers/view/authscreens/auth_screen.dart';

class mySplashScreen extends StatefulWidget {
  const mySplashScreen({super.key});

  @override
  State<mySplashScreen> createState() => _mySplashScreenState();
}

class _mySplashScreenState extends State<mySplashScreen> {
  inittimer(){
    Timer(const Duration(seconds: 3),() async
    {
      Navigator.push(context, MaterialPageRoute(builder: (c)=>AuthScreen()));
    });
  }
  @override

  void initState(){
    super.initState();

    inittimer();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(
                "images/sellers.webp"
              ),
            ),
            const Text(
              "Sellers App",
              textAlign: TextAlign.center,
              style: TextStyle(
                letterSpacing: 3,
                fontSize: 26,
                color: Colors.grey
              ),
            )
          ],
        ),
      ),
    );
  }
}
