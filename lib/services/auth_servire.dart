
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // ===========================
  // تسجيل مستخدم جديد
  // ===========================
  Future<User?> signUp(String email, String password,String username) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'username':username,
        },
      );


      return response.user;
    } on AuthException catch (e) {
      // التعامل مع خطأ التسجيل
      print('خطأ أثناء التسجيل: ${e.message}');
      return null;
    } catch (e) {
      print('خطأ غير متوقع: $e');
      return null;
    }
  }

  // ===========================
  // تسجيل الدخول
  // ===========================
  Future<User?> signIn(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      print("object");
      return response.user;
    } on AuthException catch (e) {
      print('خطأ أثناء تسجيل الدخول: ${e.message}');
      return null;
    } catch (e) {
      print('خطأ غير متوقع: $e');
      return null;
    }
  }

  // ===========================
  // تسجيل الخروج
  // ===========================
  Future<bool> signOut() async {
    try {
      await _supabase.auth.signOut();
      print("object");

      return true;
    } catch (e) {
      print('خطأ أثناء تسجيل الخروج: $e');
      return false;
    }
  }

  // ===========================
  // الاستماع لتغيرات الـ Auth
  // ===========================
  Stream<AuthChangeEvent> authStateChanges() {
    return _supabase.auth.onAuthStateChange.map((data) => data.event);
  }

  // ===========================
  // الحصول على الجلسة الحالية
  // ===========================
  Session? getCurrentSession() {
    return _supabase.auth.currentSession;
  }

  String getUsername() {
    final Username= _supabase.auth.currentUser?.userMetadata?['username'] ;
    return Username?.toString()??'';

  }


}
