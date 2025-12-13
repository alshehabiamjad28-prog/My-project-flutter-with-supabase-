
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/articles_service.dart';

import '../style.dart';
import '../widgets/post_shimmer.dart';
import '../widgets/user_aricle_widget/UserArticle_Card.dart';
import 'article_detail_screen.dart';

class UserArticle extends StatefulWidget {
  const UserArticle({super.key});

  @override
  State<UserArticle> createState() => _HomescreenState();
}

class _HomescreenState extends State<UserArticle> {
  bool loding=false;

  final user = Supabase.instance.client.auth.currentUser;

  GlobalKey<ScaffoldState> skf = GlobalKey();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Width = MediaQuery.of(context).size.width;
    final Heigth = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: backgroundColor,
        // خلفية بيضاء كاملة
        shadowColor: Colors.black.withOpacity(0.1),
        // ظل ناعم
        title: Container(
          width: 390,
          // عرض ثابت - لا يأخذ كامل المساحة
          height: 40,
          margin: EdgeInsets.symmetric(horizontal: 20),
          // مسافات جانبية
          decoration: BoxDecoration(
            color: Colors.white, // خلفية بيضاء
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
        actions: [Icon(Icons.add_alert_rounded)],
      ),

      body: SingleChildScrollView(

        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 25),
              Userdata(user!.email.toString()),
              SizedBox(height: 5),
              ?loding != true ? null : Center(child: CircularProgressIndicator(color: Colors.blue,),),


              Container(
                width: 200,
                height: Heigth * 0.80,

                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: ArticlesService().getArticleUser(user!.id),
                  builder: (context, snapshot) {
                    // حالة التحميل
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Padding(
                        padding: EdgeInsets.only(
                          top: 20.0,
                          left: 20.0,
                          right: 20.0,
                        ),                        child: ListView.builder(
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return ArticleCardShimmer();

                          },),

                      );                    }

                    // حالة الخطأ
                    if (snapshot.hasError) {
                      print('❌ خطأ في Stream: ${snapshot.error}');
                      print('📊 بيانات الخطأ: ${snapshot.stackTrace}');
                      return Center(
                        child: Text(
                          'حدث خطأ في تحميل المقالات: ${snapshot.error}',
                        ),
                      );
                    }

                    // حالة عدم وجود بيانات
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      print('📭 لا توجد بيانات أو القائمة فارغة');
                      return Center(child: Text('لا توجد مقالات متاحة'));
                    }

                    // حالة النجاح - عرض المقالات
                    final articles = snapshot.data!;
                    print('✅ عدد المقالات المستلمة: ${articles.length}');

                    return Padding(
                      padding: EdgeInsets.only(
                        top: 20.0,
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: ListView.builder(
                       physics: BouncingScrollPhysics() ,
                        shrinkWrap: false,
                        itemCount: articles.length,
                        itemBuilder: (context, index) {
                          final article = articles[index];
                          print('🔄 معالجة المقال $index: ${article['title']}');
                          print('🖼️ رابط الصورة: ${article['img_url']}');

                          return UserarticleCard(
                            authorName: article['username']?.toString()??'USER',
                            publishDate:
                                article['created_at']?.toString() ?? '',
                            imageUrl: article['image_url']?.toString() ?? '',
                            // ✅ image_url وليس img_url
                            title: article['title']?.toString() ?? '',
                            // من ArticleCard عند الضغط
                            deletonPressed: () async{
                              print(article['id']);

                              try{
                                setState(() {
                                  loding =true;
                                });
                             final delet=   await ArticlesService().deleteArticle(article['id']?.toString()??'');

                                setState(() {
                                  loding =false;
                                });
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("data")));


                              }catch(e){
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("error")));



                              }


                            },
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ArticleDetailPage(
                                    articleid: article['id']?.toString()??'',

                                    articleImage: article['image_url'] ?? '',
                                    articleTitle: article['title'] ?? '',
                                    articleDescription:
                                        article['content'] ?? '',
                                    authorName:
                                        article['author_name'] ??
                                        ' user',
                                    publishDate: article['created_at'] ?? '',
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildDefaultAvatar() {
  return Container(
    width: 300,
    height: 130,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.grey, Colors.white],
      ),
    ),
    child: const Icon(Icons.person, size: 80, color: Colors.white),
  );
}

Widget Userdata(String username) {
  return Container(
    alignment: Alignment.topCenter,
    width: 400,
    height: 200,
    child: Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        _buildDefaultAvatar(),
        SizedBox(height: 17),
        Container(child: Text(username, style: bodyTextStyle)),
      ],
    ),
  );
}
