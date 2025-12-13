import 'package:fire/style.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../widgets/user_profile_widgets/avatar_name_section.dart';
import '../widgets/user_profile_widgets/info_card_widget.dart';



class UserProfilePage extends StatelessWidget {
  final user = Supabase.instance.client.auth.currentUser;
  final String userId;
  final String userName;
  final String userEmail;
  final String? userAvatar;
  final String joinDate;
  final String? bio;

   UserProfilePage({
    Key? key,
    required this.userId,
    required this.userName,
    required this.userEmail,
    this.userAvatar,
    required this.joinDate,
    this.bio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildAppBar(),
      body: _buildProfileContent(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'Profile',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      backgroundColor: backgroundColor,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black),
      centerTitle: true,
    );
  }

  Widget _buildProfileContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
      child: Column(
        children: [
          // البطاقة الرئيسية (المكون المنفصل)
          AvatarNameSection(
            userName: userName,
            userEmail: userEmail,
            userAvatar: userAvatar,
            bio: bio,
          ),
          const SizedBox(height: 20),

          // معلومات الحساب
          _buildAccountInfoCard(),
        ],
      ),
    );
  }

  Widget _buildAccountInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Account information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          // معرّف المستخدم
          InfoCardWidget(
            icon: Icons.fingerprint,
            title: 'User id',
            value: userId,
          ),
          const SizedBox(height: 12),

          // تاريخ الانضمام
          InfoCardWidget(
            icon: Icons.calendar_today,
            title: 'Joining date',
            value: _formatDate(joinDate),
          ),
          const SizedBox(height: 12),

          // البريد الإلكتروني
          InfoCardWidget(
            icon: Icons.email,
            title: 'Email',
            value: userEmail,
          ),
          const SizedBox(height: 12),

          // حالة الحساب
          InfoCardWidget(
            icon: Icons.verified_user,
            title: 'Account status',
            value: user != null ? 'active' : 'inactive',
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}