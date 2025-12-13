import 'package:fire/services/auth_servire.dart';
import 'package:fire/utils/validators.dart';
import 'package:fire/widgets/article_card.dart';
import 'package:fire/widgets/Reply_Widgets/reply_show_model_bottom_Sheet.dart';
import 'package:fire/widgets/post_shimmer.dart';
import 'package:fire/widgets/user_aricle_widget/UserArticle_Card.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'ThemeProvider.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  final name = 'kjijk';
  String username = AuthService().getUsername();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.only(top: 50, left: 30, right: 30),
        child: Container(
          child: ListView(
            children: [IconButton(
          icon: const Icon(Icons.brightness_6),
          onPressed: () {
            context.read<ThemeProvider>().toggleTheme();
          },
        )],
          ),
        ),
      ),
    );
  }
}
