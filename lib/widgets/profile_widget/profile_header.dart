import 'package:fire/style.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String? userName;
  final String? userStats;
  final String? joinDate;
  final String? profileImage;
  final VoidCallback onEditPressed;
  final VoidCallback? onImageTap;

  const ProfileHeader({
    super.key,
    this.userName,
    this.userStats,
    this.joinDate,
    this.profileImage,
    required this.onEditPressed,
    this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // صورة البروفايل مع InkWell
          InkWell(
            onTap: onImageTap,
            borderRadius: BorderRadius.circular(50),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE5E7EB), width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipOval(
                child: profileImage != null
                    ? Image.network(
                        profileImage!,
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildDefaultAvatar();
                        },
                      )
                    : _buildDefaultAvatar(),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // الاسم
          Text(
            userName ?? "User",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),

          // الإحصائيات - تظهر فقط إذا كانت موجودة
          if (userStats != null) ...[
            Text(
              userStats!,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
          ],

          // تاريخ الانضمام - يظهر فقط إذا كان موجوداً
          if (joinDate != null) ...[
            Container(
              alignment: Alignment.center,
              width: 250,
              height: 50,

              child: SizedBox(
                height: 20,
                child: Text(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  "Member since ${joinDate.toString()}",
                  style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                ),
              )
            ),

            const SizedBox(height: 16),
          ] else ...[
            const SizedBox(height: 16),
          ],

          // زر تعديل البروفايل
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onEditPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF374151),
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Color(0xFFD1D5DB), width: 1),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.edit, size: 16, color: Color(0xFF6B7280)),
                  SizedBox(width: 8),
                  Text(
                    'Edit Profile',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // بناء الصورة الافتراضية
  Widget _buildDefaultAvatar() {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.grey, Colors.white],
        ),
      ),
      child: const Icon(Icons.person, size: 40, color: Colors.white),
    );
  }
}
