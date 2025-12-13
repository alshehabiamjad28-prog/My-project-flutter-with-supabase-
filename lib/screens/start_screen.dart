import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'signin_screen.dart';
import 'onboarding_screen.dart';
import 'listpages_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 1400), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) =>
          Supabase.instance.client.auth.currentUser != null
                ? PageList()
                :  OnboardingScreen(onFinish: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const LoginPage(),));
          },),
          transitionsBuilder: (_, a, __, c) =>
              FadeTransition(opacity: a, child: c),
          transitionDuration: const Duration(milliseconds: 450),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery
        .of(context)
        .size
        .width;
    final h = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
      body: Container(
        width: w,
        height: h,
        color: Colors.white,
        child: Center(
          child: FadeTransition(
            opacity: _fade,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: w * 0.28,
                  height: w * 0.28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white60,
                        offset: Offset(1, 10),
                          blurRadius: 3.3,
                        spreadRadius:1.1,
                        blurStyle: BlurStyle.solid



                      )
                    ]

                  ),
                  child: Icon(
                    Icons.my_library_books_outlined,
                    size: w * 0.20,
                    color: Colors.blueAccent,
                  ),
                ),
                SizedBox(height: h * 0.005),
                Text(
                  'Articles',
                  style: TextStyle(
                    fontSize: w * 0.07,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,

                    letterSpacing: 1.4,

                    shadows: [
                      Shadow(
                        color: Colors.black12,
                        offset: Offset(1, 6),
                        blurRadius: 1.1


                      )
                    ]

                  ),
                ),
                SizedBox(height: h * 0.01),
                Text(
                  'Curated stories & insights',
                  style: TextStyle(
                    fontSize: w * 0.032,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}