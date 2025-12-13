import 'package:flutter/material.dart';

class AvatarNameSection extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String? userAvatar;
  final String? bio;

  const AvatarNameSection({
    Key? key,
    required this.userName,
    required this.userEmail,
    this.userAvatar,
    this.bio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
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
        children: [
          // الصورة الشخصية
          _buildAvatar(),
          const SizedBox(height: 16),

          // الاسم
          Text(
            userName,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),

          // البريد الإلكتروني
          Text(
            userEmail,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),

          // النبذة (إذا موجودة)
          if (bio != null && bio!.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                bio!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue[800],
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.blue[100]!,
          width: 3,
        ),
      ),
      child: CircleAvatar(
        backgroundColor: Colors.blue[100],
        backgroundImage: userAvatar != null && userAvatar!.isNotEmpty
            ? NetworkImage(userAvatar!)
            : null,
        child: userAvatar == null || userAvatar!.isEmpty
            ? Icon(
          Icons.person,
          size: 40,
          color: Colors.blue[600],
        )
            : null,
      ),
    );
  }
}