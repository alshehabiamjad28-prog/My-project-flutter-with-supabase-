import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import 'auth_servire.dart';

import 'package:flutter_image_compress/flutter_image_compress.dart';


class ArticlesService {
  final SupabaseClient _supabase = Supabase.instance.client;
  String username =  AuthService().getUsername();


  // ===========================
  // إنشاء مقال جديد
  // ===========================
  Future<bool> createArticle({
    required String title,
    required String content,
    required String category,
    required String urlimage,

  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw 'المستخدم غير مسجل الدخول';

      await _supabase.from('articles').insert({
        'title': title,
        'content': content,
        'category': category,
        'user_id': user.id,
        'image_url': urlimage,
        'username':username,
      });

      print('✅ تم إنشاء المقال بنجاح: $title');
      print('🖼️ مسار الصورة المحفوظ: $urlimage');
      return true;
    } catch (e) {
      print('❌ خطأ أثناء إنشاء المقال: $e');
      return false;
    }
  }

  // ===========================
  // الاستماع لجميع المقالات في الوقت الحقيقي
  // ===========================
  Stream<List<Map< String, dynamic>>> getArticlesStream() {
    return _supabase
        .from('articles')
        .stream(primaryKey: ['id']) // المفتاح الأساسي للمقالات
        .order('created_at', ascending: false)
        .map((event) => List<Map<String, dynamic>>.from(event));
  }

  Stream<List<Map<String, dynamic>>> getArticleUser(String userId) {
    try {
      return _supabase
          .from('articles')
          .stream(primaryKey: ['id'])
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .map((articles) =>
          articles.map((article) =>
          Map<String, dynamic>.from(article)
          ).toList()
      );
    } catch (e) {
      print('Error in getArticleUser: $e');
      return Stream.value([]); // إرجاع stream فارغ في حالة الخطأ
    }
  }


  // ===========================
  // تحديث مقال
  // ===========================
  Future<bool> updateArticle({
    required String articleId,
    String? title,
    String? content,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw 'المستخدم غير مسجل الدخول';

      Map<String, dynamic> updateData = {};
      if (title != null) updateData['title'] = title;
      if (content != null) updateData['content'] = content;
      updateData['updated_at'] = DateTime.now().toIso8601String();

      await _supabase
          .from('Articles')
          .update(updateData)
          .eq('id', articleId)
          .eq('author_id', user.id); // فقط صاحب المقال يمكنه التعديل

      return true;
    } catch (e) {
      print('خطأ أثناء تحديث المقال: $e');
      return false;
    }
  }

  // ===========================
  // حذف مقال
  // ===========================
  Future<bool> deleteArticle(String articleId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw 'المستخدم غير مسجل الدخول';

      await _supabase
          .from('articles')
          .delete()
          .eq('id', articleId)
          .eq('user_id', user.id);
             await _supabase.from('articles').select('id').limit(1);



      return true;
    } catch (e) {
      print('خطأ أثناء حذف المقال: $e');
      return false;
    }
  }

  // ===========================
  // جلب مقال واحد حسب الـ ID
  // ===========================
  Future<Map<String, dynamic>?> getArticleById(String articleId) async {
    try {
      final response = await _supabase
          .from('Articles')
          .select()
          .eq('id', articleId)
          .maybeSingle();

      return response as Map<String, dynamic>?;
    } catch (e) {
      print('خطأ أثناء جلب المقال: $e');
      return null;
    }
  }

  Future<String> uploadImage(File file) async {
    try {
      String uuid = Uuid().v4();
      String ext = file.path.split('.').last;
      final File compressedFile = await _compressImage(file);
      final path = '$uuid.$ext';

      await _supabase.storage
          .from('notes')
          .upload(path, compressedFile);

      // 🔥 إرجاع الرابط الكامل مباشرة
      final String fullUrl = 'https://nrwxeqhdkheimsxvizis.supabase.co/storage/v1/object/public/notes/$path';
      print('✅ تم رفع الصورة: $fullUrl');
      return fullUrl;

    } catch (e) {
      print('❌ خطأ في رفع الصورة: $e');
      throw e;
    }
  }

  Future<File> _compressImage(File file) async {
    try {
      final fileLength = await file.length();

      if (fileLength < 500 * 1024) {
        return file;
      }

      final String originalPath = file.path;
      final String compressedPath = '${originalPath}_compressed.jpg';

      final XFile? compressedFile = await FlutterImageCompress.compressAndGetFile(
        originalPath,
        compressedPath,
        quality: 70,
      );

      return compressedFile != null ? File(compressedFile.path) : file;
    } catch (e) {
      return file;
    }
  }

// الدالة 2: الحصول على رابط الصورة
  String getImageUrl(String imagePath) {
    try {
      // دائماً أضف 'public/' لأن الصور مخزنة في مجلد public
      String cleanPath = 'public/$imagePath';
      final String publicUrl = _supabase.storage.from('notes').getPublicUrl(cleanPath);

      print('🔗 رابط الصورة النهائي: $publicUrl');
      return publicUrl;

    } catch (e) {
      print('❌ خطأ في إنشاء رابط الصورة: $e');
      return '';
    }
  }


  // في ملف articles_service.dart

  Future<List<Map<String, dynamic>>> searchArticles(String query) async {
    try {
      if (query.isEmpty) {
        return []; // إرجاع قائمة فارغة إذا كان البحث فارغاً
      }

      final response = await _supabase
          .from('articles')
          .select()
          .or('title.ilike.%$query%,content.ilike.%$query%,category.ilike.%$query%')
          .order('created_at', ascending: false);

      print('✅ تم العثور على ${response.length} نتيجة للبحث: $query');
      return response;
    } catch (e) {
      print('❌ خطأ في البحث: $e');
      return [];
    }
  }




}
