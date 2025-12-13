import 'package:flutter/material.dart';

class ReplyButton extends StatelessWidget {
  final String text;
  final  void Function() onPressed;

  const ReplyButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[700], // اللون الأساسي
        foregroundColor: Colors.white, // لون النص
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: Text(text),
    );
  }
}