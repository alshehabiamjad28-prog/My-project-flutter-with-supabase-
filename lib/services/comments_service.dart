import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth_servire.dart';

class CommentsService {
  final _supabase = Supabase.instance.client;
  String username =  AuthService().getUsername();
  final user = Supabase.instance.client.auth.currentUser;



  // 1. ✅ إضافة تعليق إلى مقال معين
  Future<bool> addComment({required String text, required String articleId}) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return false;

      await _supabase.from('comments').insert({
        'article_id': articleId,
        'user_id': user.id,
        'content': text,
         'user_name':user.email,
      });
      await _supabase.from('articles').select('id').limit(1);


      print("✅ Comment added successfully");
      return true;
    } catch (e) {
      print("❌ Error adding comment: ${e.toString()}");
      return false;
    }
  }

  // 2. ✅ حذف التعليق حسب الـ ID الخاص به
  Future<bool> removeComment({required String commentId}) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return false;

      await _supabase.from('comments')
          .delete()
          .eq('id', commentId)
          .eq('user_id', user.id); // التأكد من ملكية المستخدم للتعليق
      await _supabase.from('articles').select('id').limit(1);

      print("✅ Comment removed successfully");
      return true;
    } catch (e) {
      print("❌ Error removing comment: ${e.toString()}");
      return false;
    }
  }

  // 3. ✅ تحديث التعليق
  Future<bool> updateComment({required String text, required String commentId}) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return false;

      await _supabase.from('comments').update({
        'content': text,
        'updated_at': DateTime.now().toIso8601String(),
      })
          .eq('id', commentId) // البحث بالتعليق ID
          .eq('user_id', user.id);
      await _supabase.from('articles').select('id').limit(1);
// التأكد من ملكية المستخدم

      print("✅ Comment updated successfully");
      return true;
    } catch (e) {
      print("❌ Error updating comment: ${e.toString()}");
      return false;
    }
  }

  // 4. ✅ عرض جميع التعليقات المرتبطة بمقال معين
  Stream<List<Map<String, dynamic>>> getArticleComments(String articleId) {
    try {
      return _supabase
          .from('comments')
          .stream(primaryKey: ['id'])
          .eq('article_id', articleId) // ✅ فلتر بالمقال المحدد فقط
          .order('created_at', ascending: true) // ✅ من الأقدم إلى الأحدث
          .map((comments) =>
          comments.map((comment) =>
          Map<String, dynamic>.from(comment)
          ).toList()
      );
    } catch (e) {
      print('❌ Error in getArticleComments: $e');
      return Stream.value([]);
    }
  }
}