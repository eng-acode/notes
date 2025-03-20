import 'dart:async';
import 'package:flutter/material.dart';
import 'package:notes_app/components/text_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
      () => Navigator.pushNamedAndRemoveUntil(
        context,
        '/homepage',
        (Route<dynamic> route) => false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff333333),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image.asset('assets/note_animated.gif', fit: BoxFit.cover),
          ),

          Transform.translate(
            offset: Offset(0, -40),
            child: Divider(
              height: 10.0,
              color: Colors.white,
              indent: 100,
              endIndent: 100,
            ),
          ),

          // Custom Text Widget
          Transform.translate(
            offset: Offset(0, -30),
            child: TextWidget(
              title: 'NOTES',
              fontFamily: 'Pacifico',
              fontSize: 18.0,
              fontWeight: FontWeight.normal,
              fontColor: Colors.white,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}
