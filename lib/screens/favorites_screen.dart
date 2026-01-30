import 'package:cached_network_image/cached_network_image.dart';
import 'package:fire/style.dart';
import 'package:fire/widgets/favorite_screen_widgets/article_shimmer_card.dart';
import 'package:flutter/material.dart';

import '../services/favorites_service.dart';
import 'article_detail_screen.dart' show ArticleDetailPage;

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final FavoritesService _favoritesService = FavoritesService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Favorites',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: backgroundColor,
        iconTheme: IconThemeData(color: Colors.black87),
        centerTitle: true,
      ),
      body: _buildFavoritesList(),
    );
  }

  Widget _buildFavoritesList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _favoritesService.getFavoritesWithArticles(),
      builder: (context, snapshot) {
        // حالة التحميل
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }

        // حالة الخطأ
        if (snapshot.hasError) {
          return _buildErrorState();
        }

        // حالة عدم وجود بيانات
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyState();
        }

        // حالة النجاح - عرض المفضلات
        final favorites = snapshot.data!;
        return _buildFavoritesGrid(favorites);
      },
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: EdgeInsets.only(left: 16,right: 16,bottom: 20),
      child: ListView.builder(

        itemCount: 4,
        itemBuilder: (context, index) {
        return SimpleArticleShimmer();

      },),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'An error occurred   ',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => setState(() {}),
            child: Text('  Try again'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: Colors.grey[300],
          ),
          SizedBox(height: 20),
          Text(
            "No favorite articles",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Press Add to add articles to favorites',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesGrid(List<Map<String, dynamic>> favorites) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: ListView.separated(
        itemCount: favorites.length,
        separatorBuilder: (context, index) => SizedBox(height: 16),
        itemBuilder: (context, index) {
          final favorite = favorites[index];
          final article = favorite['article'];

          if (article == null || article.isEmpty) {
            return SizedBox();
          }

          return _buildFavoriteCard(favorite, article);
        },
      ),
    );
  }

  Widget _buildFavoriteCard(Map<String, dynamic> favorite, Map<String, dynamic> article) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            _openArticleDetail(article);
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // صورة المقال
                _buildArticleImage(article),

                SizedBox(width: 12),

                // محتوى المقال
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // العنوان
                      Text(
                        article['title']?.toString() ?? ' Null',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 8),

                      // الوصف
                      Text(
                        article['content']?.toString() ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 12),

                      // معلومات إضافية
                      _buildArticleInfo(article),
                    ],
                  ),
                ),

                // زر الحذف
                _buildDeleteButton(favorite, article),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildArticleImage(Map<String, dynamic> article) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[200],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child:  CachedNetworkImage(
          imageUrl:  article['image_url']?.toString() ?? '',
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.grey[200],
            child: Center(child: CircularProgressIndicator()),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey[200],
            child: Icon(Icons.article, size: 60, color: Colors.grey[400]),
          ),
        ),

      ),
    );
  }

  Widget _buildArticleInfo(Map<String, dynamic> article) {
    return Row(
      children: [
        // المؤلف
        Icon(Icons.person_outline, size: 14, color: Colors.grey[500]),
        SizedBox(width: 4),
        Expanded(
          child: Text(
            article['username']?.toString() ?? 'USER',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),

        SizedBox(width: 12),

        // التاريخ
        Icon(Icons.calendar_today, size: 14, color: Colors.grey[500]),
        SizedBox(width: 4),
        Text(
          _formatDate(article['created_at']?.toString() ?? ''),
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  Widget _buildDeleteButton(Map<String, dynamic> favorite, Map<String, dynamic> article) {
    return IconButton(
      onPressed: _isLoading ? null : () => _removeFromFavorites(article),
      icon: _isLoading
          ? SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      )
          : Icon(
        Icons.favorite,
        color: Colors.red,
        size: 24,
      ),
    );
  }

  void _removeFromFavorites(Map<String, dynamic> article) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final success = await _favoritesService.removeFromFavorites(article['id']?.toString()??'');

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Favorites deleted successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error occurred while deleting'),
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _openArticleDetail(Map<String, dynamic> article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArticleDetailPage(
          articleid: article['id']?.toString()??'',
          articleImage: article['image_url']?.toString() ?? '',
          articleTitle: article['title']?.toString() ?? '',
          articleDescription: article['content']?.toString() ?? '',
          authorName: article['username']?.toString() ?? 'USER',
          publishDate: article['created_at']?.toString() ?? '',
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'تاريخ غير معروف';
    }
  }
}