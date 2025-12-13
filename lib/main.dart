import 'package:fire/screens/start_screen.dart';
import 'package:fire/test.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'ThemeProvider.dart';

// 👉 أضف هذا الاستيراد (عدّل المسار حسب مكان الملف)

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://nrwxeqhdkheimsxvizis.supabase.co",
    anonKey:
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5yd3hlcWhka2hlaW1zeHZpemlzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE0ODQ1MjgsImV4cCI6MjA3NzA2MDUyOH0.aOCgoUJoywrTTwnmZezBmM0Wqyh77934r29xPPftpsY",
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        textTheme: const TextTheme(),
      ),

      darkTheme: ThemeData.dark(useMaterial3: true),

      themeMode: themeProvider.themeMode,

      home: StartScreen(),
      // home: Supabase.instance.client.auth.currentUser != null
      //     ? PageList()
      //     : LoginPage(),
    );
  }
}