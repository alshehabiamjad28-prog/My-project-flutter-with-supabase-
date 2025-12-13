

import 'package:flutter/material.dart';

class InteractionButton extends StatelessWidget {

  final IconData icon;
  final String text;
  final VoidCallback onPressed;
  final int? count;

  const InteractionButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;


    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: width*0.04, color: Colors.grey[700]),
      label: count != null
          ? Text("$text ($count)",style: TextStyle(fontSize: 12,color: Colors.black),)
          : Text(text,style: TextStyle(fontSize: 12,color: Colors.black)),
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: height*0.006, vertical: width*0.004),
        minimumSize: Size.zero,
      ),
    );
  }
}