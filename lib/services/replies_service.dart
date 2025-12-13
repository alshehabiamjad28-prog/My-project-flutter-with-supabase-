import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth_servire.dart';

class RepliesService {
  final _user = Supabase.instance.client.auth.currentUser;
  final _supabase = Supabase.instance.client;
  String username = AuthService().getUsername();

  Future<bool> InsertReply(String content, String commentid) async {
    try {
      if (_user == null) return false;

      await _supabase.from('Replies').insert({
        'content': content,
        'username': _user.email,
        'user_id': _user.id,
        'comment_id': commentid,
      });
      await _supabase.from('articles').select('id').limit(1);

      print("✅ Comment added successfully");
      return true;
    } catch (e) {
      print("❌ Error adding comment: ${e.toString()}");

      return false;
    }
  }

  Future<bool> updateComment(String content, String commentid) async {
    try {
      if (_user == null) return false;

      final commentIdInt = int.parse(commentid);

      print("🔄 جرب التحديث مع تصحيح التاريخ...");

      await _supabase
          .from('Replies')
          .update({
        'content': content,
        'updated_at': DateTime.now().toUtc().toIso8601String(), // ✅ التصحيح
      })
          .eq('id', commentIdInt)
          .eq('user_id', _user.id);
      await _supabase.from('articles').select('id').limit(1);


      print("✅ التحديث تم بنجاح");

      // تحقق من التحديث
      final updatedData = await _supabase
          .from('Replies')
          .select('content, updated_at')
          .eq('id', commentIdInt)
          .single();

      print("📊 البيانات بعد التحديث: $updatedData");

      return true;
    } catch (e) {
      print("❌ خطأ كامل: ${e.toString()}");
      return false;
    }
  }


  Future<bool> Deletcomment(String commentid) async {
    try {
      if (_user == null) return false;

      await _supabase
          .from('Replies')
          .delete()
          .eq('id', commentid)
          .eq('user_id', _user.id);
      await _supabase.from('articles').select('id').limit(1);
      await _supabase.from('articles').select('id').limit(1);


      print("✅   successfully");

      return true;
    } catch (e) {
      print("❌ Error : ${e.toString()}");

      return false;
    }
  }

  Stream<List<Map<String, dynamic>>> getReplies(String commentid) {
    try {
      return _supabase
          .from('Replies')
          .stream(primaryKey: ['id'])
          .eq('comment_id', commentid)
          .order('created_at', ascending: true)
          .map(
            (comments) => comments
                .map((comment) => Map<String, dynamic>.from(comment))
                .toList(),
          );
    } catch (e) {
      print("❌ Error : ${e.toString()}");

      return Stream.value([]);
    }
  }
}
