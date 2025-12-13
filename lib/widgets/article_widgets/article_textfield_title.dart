import 'package:flutter/cupertino.dart';

import '../form_input_field.dart';

class ArticleTextfieldTitle extends StatelessWidget {
  final String? Function(String?)? valdator;
  final controller;

  const ArticleTextfieldTitle({super.key, this.valdator, this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD1D5DB)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Forminputfield(
        hint: "Article Title",
        controller: controller,
        valdator: valdator,
      ),
    );
  }
}
