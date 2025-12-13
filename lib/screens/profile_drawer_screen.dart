
import 'package:fire/screens/start_screen.dart';
import 'package:fire/style.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_servire.dart';
import '../widgets/Profile_widget/menu_card.dart';

import '../widgets/Profile_widget/profile_header.dart';
import 'signin_screen.dart';
import 'user_article_screen.dart';
import 'user_profile_screen.dart';

class ProfileDrawer extends StatelessWidget {
  final user =Supabase.instance.client.auth.currentUser;
  String username =  AuthService().getUsername();


  ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: backgroundColor,
      child: Column(
        children: [


          ProfileHeader(

            userName: username,
            joinDate: user!.createdAt,
            onImageTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserProfilePage(userId: user!.id.toString(), userName: username, userEmail: user!.email.toString(), joinDate: user!.createdAt),));

            },

            onEditPressed: () {

          },),

          // قائمة الخيارات
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 20),
              children: [
                MenuCard(
                  title: "My Articles",
                  subtitle: "View your published articles",
                  icon: Icons.article,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserArticle(),));
                    // انتقل لصفحة المقالات
                  },
                ),

                MenuCard(
                  title: "Settings",
                  subtitle: "App preferences and settings",
                  icon: Icons.settings,
                  onTap: () {
                    Navigator.pop(context);
                    // انتقل لصفحة الإعدادات
                  },
                ),

                MenuCard(
                  title: "Logout",
                  subtitle: "Sign out from your account",
                  icon: Icons.logout,
                  onTap: ()async {
                    Navigator.of(context).pushReplacement( MaterialPageRoute(builder: (context) =>StartScreen(),));

                    await AuthService().signOut();
                     ScaffoldMessenger.of(context).showSnackBar(

                         SnackBar(
                           backgroundColor: Color.fromARGB(255, 116, 241, 116),
                             content: Text("Log out successful")));
                    // وظيفة تسجيل الخروج
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}