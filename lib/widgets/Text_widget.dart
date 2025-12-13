import 'package:flutter/cupertino.dart';

class TextWidget extends StatelessWidget {
  final String title;
  const TextWidget ({super.key, required this.title, });

  @override
  Widget build(BuildContext context) {
    return   Text(
         title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFF374151),
      ),
    );
  }
}
