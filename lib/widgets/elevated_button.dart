import 'package:flutter/material.dart';

import '../style.dart';

class Elevatedbutton extends StatelessWidget {
  final title;
  final void Function()? onPressed;

  const Elevatedbutton({super.key, this.title, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return    ElevatedButton(

      style: primaryButtonStyle,

      onPressed: onPressed,
      child: Container(

        width: 260,
        height: 23,
        child: Center(child: Text(title,style: TextStyle(color: Colors.white),)),
      ),
    );
  }
}
