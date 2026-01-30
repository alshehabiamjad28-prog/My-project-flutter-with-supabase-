import 'package:fire/screens/signin_screen.dart';
import '../../../../Mobile apps/myproject/lib/screens/start_screen.dart';
import 'package:fire/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/auth_servire.dart';
import '../services/user_repository_service.dart';
import '../widgets/Profile_widget/menu_card.dart';

class SettingsPage extends StatefulWidget {



  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final currentUser = Supabase.instance.client.auth.currentUser;
  Future<void> logoutUser() async {
    try {
      // جلب معرف المستخدم الحالي


      if (currentUser != null) {
        // استدعاء دالة حذف المستخدم من UserRepository
        final success = await UserRepository().deleteUser(currentUser!.id);

        if (success) {
          // ✅ تسجيل الخروج ناجح
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Color.fromARGB(255, 125, 246, 133),
              content: Text("Logout successful"),
            ),
          );

          // التنقل إلى صفحة تسجيل الدخول
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => StartScreen()),
          );
        } else {
          // ❌ فشل في تسجيل الخروج
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Color.fromARGB(255, 255, 90, 65),
              content: Text("Failed to logout"),
            ),
          );
        }
      } else {
        // ❌ لا يوجد مستخدم مسجل دخول
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color.fromARGB(255, 255, 90, 65),
            content: Text("No user is currently logged in"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color.fromARGB(255, 255, 90, 65),
          content: Text("An error occurred during logout: $e"),
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const Text(
            "Settings",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              fontSize: 24,
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Account
          MenuCard(
            title: "Account",
            subtitle: "Manage your account",
            icon: Icons.person,
            onTap: () {
              // Navigate to account settings
            },
          ),

          const SizedBox(height: 12),

          // Article Settings
          MenuCard(
            title: "Article Settings",
            subtitle: "Customize your articles",
            icon: Icons.article,
            onTap: () {
              // Navigate to article settings
            },
          ),

          const SizedBox(height: 12),

          // Language
          MenuCard(
            title: "Language",
            subtitle: "App language and region",
            icon: Icons.language,
            onTap: () {
              // Navigate to language settings
            },
          ),

          const SizedBox(height: 12),

          // Notifications
          MenuCard(
            title: "Notifications",
            subtitle: "Manage notifications",
            icon: Icons.notifications,
            onTap: () {
              // Navigate to notification settings
            },
          ),

          const SizedBox(height: 12),

          // Privacy
          MenuCard(
            title: "Privacy",
            subtitle: "Privacy and security",
            icon: Icons.security,
            onTap: () {
              // Navigate to privacy settings
            },
          ),

          const SizedBox(height: 12),

          // App Info
          MenuCard(
            title: "App Info",
            subtitle: "Storage and version",
            icon: Icons.info,
            onTap: () {
              // Navigate to app info
            },
          ),
          MenuCard(
            title: "Delet account",
            subtitle: "Permanently delete the account",
            icon: Icons.login_outlined,
            onTap: () {
              showDialog(context: context, builder: (context) =>
              CustomDialog(
                icon: Icons.error_outline,
                title: "Delet account",
                subtitle: "are you sure you want to delete the account?",
                onCancel: () {
                  Navigator.of(context).pop();
                },
                onConfirm: ()async {
                  Navigator.of(context).pop();
                  await logoutUser();

                },)
              );
              // Navigate to app info
            },
          ),
        ],
      ),
    );
  }
}
