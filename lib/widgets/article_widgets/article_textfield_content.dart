import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ArticleTextfieldContent extends StatelessWidget {
  final String? Function(String?)? valdator;
  final controller;

  const ArticleTextfieldContent({super.key, this.valdator, this.controller,});

  @override
  Widget build(BuildContext context) {
    return    Container(
      height: 280,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD1D5DB)),
        borderRadius: BorderRadius.circular(8),
      ),
      child:  TextFormField(
        validator: valdator,
        controller: controller,
        maxLines: null,
        expands: true,
        decoration: InputDecoration(
          hintText: 'Write your article...',
          contentPadding: EdgeInsets.all(12),
          border: InputBorder.none,
          hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
          alignLabelWithHint: true,
        ),
      ),
    );
  }
}
