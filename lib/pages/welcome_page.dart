import 'package:flutter/material.dart';
import 'package:notes_app/components/text_widget.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(image: AssetImage('assets/take_note.png')),

        Divider(height: 10.0, color: Colors.white, indent: 100, endIndent: 100),

        // Custom Text Widget
        TextWidget(
          title: 'Start Adding Notes',
          fontFamily: 'Pacifico',
          fontSize: 18.0,
          fontWeight: FontWeight.normal,
          fontColor: Colors.white,
          letterSpacing: 2,
        ),
      ],
    );
  }
}
