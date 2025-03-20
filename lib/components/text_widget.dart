import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String title;
  final String fontFamily;
  final double fontSize;
  final Color fontColor;
  final FontWeight? fontWeight;
  final double? letterSpacing;

  const TextWidget({
    required this.title,
    required this.fontFamily,
    required this.fontSize,
    required this.fontColor,
    required this.letterSpacing,
    required this.fontWeight,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final customStyle = TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      color: fontColor,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
    );
    return Text(title, style: customStyle);
  }
}
