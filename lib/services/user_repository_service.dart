import 'package:supabase_flutter/supabase_flutter.dart';

class UserRepository {
  final SupabaseClient _supabase = Supabase.instance.client;
  final String tableName = 'user'; // اسم الجدول الذي يحتوي بيانات المستخدمين

  // ===========================
  // إضافة مستخدم جديد أو تحديث بياناته
  // ===========================
  Future<bool> createOrUpdateUser({
    required String id,
    required String username,
    String? avatarUrl,
    String? role,
  }) async {
    try {
      final response = await _supabase.from(tableName).upsert({
        'id': id,
        'username': username,
        'avatar_url': avatarUrl,
        'role': role,
      });
      return response != null;
    } catch (e) {
      print('خطأ أثناء حفظ بيانات المستخدم: $e');
      return false;
    }
  }

  // ===========================
  // قراءة بيانات المستخدم
  // ===========================
  Future<Map<String, dynamic>?> getUserById(String id) async {
    try {
      final response = await _supabase.from(tableName).select().eq('id', id).single();
      return response;
    } catch (e) {
      print('خطأ أثناء جلب بيانات المستخدم: $e');
      return null;
    }
  }

  // ===========================
  // تحديث بيانات المستخدم
  // ===========================
  Future<bool> updateUser({
    required String id,
    String? username,
    String? avatarUrl,
    String? role,
  }) async {
    try {
      final response = await _supabase.from(tableName).update({
        if (username != null) 'username': username,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
        if (role != null) 'role': role,
      }).eq('id', id);
      return response != null;
    } catch (e) {
      print('خطأ أثناء تحديث بيانات المستخدم: $e');
      return false;
    }
  }

  // ===========================
  // حذف مستخدم
  // ===========================
  Future<bool> deleteUser(String id) async {
    try {
      final response = await _supabase.from(tableName).delete().eq('id', id);
      return response != null;
    } catch (e) {
      print('خطأ أثناء حذف المستخدم: $e');
      return false;
    }
  }
}