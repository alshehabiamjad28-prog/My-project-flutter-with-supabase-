import 'package:supabase_flutter/supabase_flutter.dart';

class FavoritesService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // 1. ✅ دالة التحقق من وجود المقال في المفضلة
  Future<bool> isArticleInFavorites(String articleId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return false;

      final response = await _supabase
          .from('favorites')
          .select()
          .eq('user_id', user.id)
          .eq('article_id', articleId);

      return response.isNotEmpty;
    } catch (e) {
      print('❌ خطأ في التحقق من المفضلة: $e');
      return false;
    }
  }

  // 2. ✅ دالة الإضافة مع التحقق من التكرار
  Future<bool> addToFavorites(String articleId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw 'يجب تسجيل الدخول أولاً';

      // التحقق من عدم التكرار
      final alreadyExists = await isArticleInFavorites(articleId);
      if (alreadyExists) {
        throw 'المقال مضاف مسبقاً في المفضلة';
      }

      // الإضافة
      await _supabase.from('favorites').insert({
        'user_id': user.id,
        'article_id': articleId,
        'created_at': DateTime.now().toIso8601String(),

      });

      print('✅ تم إضافة المقال للمفضلة: $articleId');
      return true;
    } catch (e) {
      print('❌ خطأ في إضافة المفضلة: $e');
      return false;
    }
  }

  // 3. ✅ دالة الحذف
  Future<bool> removeFromFavorites(String articleId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw 'يجب تسجيل الدخول أولاً';

      await _supabase
          .from('favorites')
          .delete()
          .eq('user_id', user.id)
          .eq('article_id', articleId);

      print('✅ تم حذف المقال من المفضلة: $articleId');
      return true;
    } catch (e) {
      print('❌ خطأ في حذف المفضلة: $e');
      return false;
    }
  }

  // 4. ✅ دالة العرض باستخدام Stream مع asyncMap
  Stream<List<Map<String, dynamic>>> getFavoritesWithArticles() {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return Stream.value([]);

      return _supabase
          .from('favorites')
          .stream(primaryKey: ['id'])
          .eq('user_id', user.id)
          .order('created_at', ascending: false)
          .asyncMap((favorites) async {
        // جلب بيانات المقالات لكل مفضلة
        final favoritesWithArticles = await Future.wait(
          favorites.map((favorite) async {
            try {
              final articleResponse = await _supabase
                  .from('articles')
                  .select()
                  .eq('id', favorite['article_id'])
                  .single();

              return {
                ...favorite,
                'article': articleResponse,
              };
            } catch (e) {
              print('❌ خطأ في جلب المقال: ${favorite['article_id']}');
              return {
                ...favorite,
                'article': {},
              };
            }
          }).toList(),
        );

        return favoritesWithArticles;
      });
    } catch (e) {
      print('❌ خطأ في جلب المفضلات: $e');
      return Stream.value([]);
    }
  }

  // 5. ✅ دالة الحذف بواسطة favoriteId
  Future<bool> removeFavoriteById(String favoriteId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw 'يجب تسجيل الدخول أولاً';

      await _supabase
          .from('favorites')
          .delete()
          .eq('id', favoriteId)
          .eq('user_id', user.id);

      print('✅ تم حذف المفضلة: $favoriteId');
      return true;
    } catch (e) {
      print('❌ خطأ في حذف المفضلة: $e');
      return false;
    }
  }
}