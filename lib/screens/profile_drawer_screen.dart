
import 'package:fire/screens/setting_screen.dart';
import '../../../../Mobile apps/myproject/lib/screens/start_screen.dart';
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
  final Function(int)? onChangePage;


  final user =Supabase.instance.client.auth.currentUser;
  String username =  AuthService().getUsername();


  ProfileDrawer({super.key, this.onChangePage});

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

                // 1. المفضلات
                MenuCard(
                  title: "Favorites",
                  subtitle: "Your favorite articles",
                  icon: Icons.favorite,
                  onTap: () {
                    Navigator.pop(context);
                     onChangePage?.call(2);
                  },
                ),

// 2. مقال جديد
                MenuCard(
                  title: "New Article",
                  subtitle: "Write a new article",
                  icon: Icons.edit,
                  onTap: () {
                    Navigator.pop(context);
                    onChangePage?.call(1);

                  },
                ),


                MenuCard(
                  title: "Settings",
                  subtitle: "App preferences and settings",
                  icon: Icons.settings,
                  onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsPage(),))    ;                // انتقل لصفحة الإعدادات
                  },
                ),


// 3. المساعدة والدعم
                MenuCard(
                  title: "Help & Support",
                  subtitle: "Help center and FAQs",
                  icon: Icons.help,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),

// 4. عن التطبيق
                MenuCard(
                  title: "About App",
                  subtitle: "App information and version",
                  icon: Icons.info,
                  onTap: () {
                    Navigator.pop(context);
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