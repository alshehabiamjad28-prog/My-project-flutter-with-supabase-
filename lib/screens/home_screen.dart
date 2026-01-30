import 'package:fire/widgets/article_card.dart';
import 'package:fire/widgets/post_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../ThemeProvider.dart';
import '../services/articles_service.dart';
import '../services/favorites_service.dart';
import '../style.dart';
import '../widgets/Profile_widget/profile_header.dart';
import '../widgets/reusable_search_widget.dart';
import 'article_detail_screen.dart';
import 'profile_drawer_screen.dart';

class Homescreen extends StatefulWidget {
  final Function(int)? onChangePage;
  const Homescreen({super.key, this.onChangePage});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final FavoritesService _favoritesService = FavoritesService();
  final user = Supabase.instance.client.auth.currentUser;
  bool loding = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void _removeFromFavorites( String articleId) async {
    // setState(() {
    //   _isLoading = true;
    // });

    try {
      final success = await _favoritesService.removeFromFavorites(
       articleId
      );

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
    }
    // finally {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // }
  }

  AddFavority(String articleId) async {
    try {
      final addfav = await FavoritesService().addToFavorites(articleId);

      if (addfav) {
        // ✅ تمت الإضافة بنجاح
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("✅ Article added to favorites"),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        // ❌ فشل الإضافة
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("❌ Failed to add article to favorites"),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      // ⚠️ حدث خطأ أثناء الإضافة
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("⚠️ An error occurred"),
            duration: Duration(seconds: 2),
          ),
        );
      }
      print('❌ خطأ في إضافة المفضلة: $e');
    }
  }

  GlobalKey<ScaffoldState> skf = GlobalKey();

  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  @override
  Widget build(BuildContext context) {
    final Width = MediaQuery.of(context).size.width;
    final Heigth = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        // خلفية بيضاء كاملة
        // ظل ناعم
        title: Container(
          width: 390,
          // عرض ثابت - لا يأخذ كامل المساحة
          height: 40,
          margin: EdgeInsets.symmetric(horizontal: 20),
          // مسافات جانبية
          decoration: BoxDecoration(
            color: backgroundColor, // خلفية بيضاء
            borderRadius: BorderRadius.circular(8), // زوايا مربعة ناعمة
            border: Border.all(
              color: Colors.grey[300]!, // حواف بلون رمادي فاتح
              width: 1,
            ),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.black.withOpacity(0.05),
            //     blurRadius: 4,
            //     offset: Offset(0, 2),
            //   ),
            // ],
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search...',
              hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
              prefixIcon: Icon(Icons.search, color: Colors.grey[500], size: 20),
              border: InputBorder.none,
              // إزالة الحدود الداخلية
              contentPadding: EdgeInsets.only(bottom: 2), // محاذاة رأسية
            ),
            style: TextStyle(color: Colors.black87, fontSize: 14),
            onChanged: (query) {
              _performSearch(query);
            },
          ),
        ),
        centerTitle: true,
        // لجعل العنوان في المنتصف
        iconTheme: IconThemeData(
          color: Colors.black87, // لون أيقونة الدروار
        ),
        toolbarHeight: 60,
        //
        // ارتفاع مناسب
        actions: [
          IconButton(
            icon: const Icon(Icons.lightbulb_outline_rounded),
            onPressed: () {
              context.read<ThemeProvider>().toggleTheme();
            },
          ),
        ],
      ),

      drawer: ProfileDrawer(onChangePage: widget.onChangePage,),

      // drawer: ProfileDrawer(),
      body: SafeArea(
        child: Container(
          child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: ArticlesService().getArticlesStream(),
            builder: (context, snapshot) {
              // حالة التحميل
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                  child: ListView.builder(
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return ArticleCardShimmer();
                    },
                  ),
                );
              }

              // حالة الخطأ
              if (snapshot.hasError) {
                print('❌ خطأ في Stream: ${snapshot.error}');
                print('📊 بيانات الخطأ: ${snapshot.stackTrace}');
                return _buildErrorState();
              }

              // حالة عدم وجود بيانات
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                print('📭 لا توجد بيانات أو القائمة فارغة');
                return Center(child: Text('"No articles found"'));
              }

              // حالة النجاح - عرض المقالات
              final articles = snapshot.data!;
              print('✅ عدد المقالات المستلمة: ${articles.length}');

              return Padding(
                padding: EdgeInsets.only(
                  top: 35.0,
                  left: 20.0,
                  right: 20.0,
                  bottom: 20,
                ),
                child: ListView.builder(
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    final article = articles[index];
                    print('🔄 معالجة المقال $index: ${article['title']}');
                    print('🖼️ رابط الصورة: ${article['img_url']}');

                    return ArticleCard(
                      articleid: article['id']?.toString() ?? '',
                      authorName: article['username']?.toString() ?? 'User',
                      publishDate: article['created_at']?.toString() ?? '',
                      imageUrl: article['image_url']?.toString() ?? '',
                      // ✅ image_url وليس img_url
                      title: article['title']?.toString() ?? '',
                      // من ArticleCard عند الضغط
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArticleDetailPage(
                              articleid: article['id']?.toString() ?? '',

                              articleImage: article['image_url'] ?? '',
                              articleTitle: article['title'] ?? '',
                              articleDescription: article['content'] ?? '',
                              authorName: article['username'] ?? 'User',
                              publishDate: article['created_at'] ?? '',
                            ),
                          ),
                        );
                      },
                      onPressedl: () async {
                        AddFavority(article['id']?.toString() ?? '');
                      },
                      onPresseddelet: () {
                        _removeFromFavorites(article['id']?.toString() ?? '');
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            '"An error occurred "',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => setState(() {}),
            child: Text(' Try again'),
          ),
        ],
      ),
    );
  }

  void _performSearch(String query) async {
    final results = await ArticlesService().searchArticles(query);
    setState(() {
      _searchResults = results;
    });
  }
}
