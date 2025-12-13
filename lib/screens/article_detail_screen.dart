import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';


import 'comments_screen.dart';

class ArticleDetailPage extends StatelessWidget {



  final String articleImage;
  final String articleTitle;
  final String articleDescription;
  final String authorName;
  final String publishDate;
  final String articleid;


  const ArticleDetailPage({
    Key? key,
    required this.articleImage,
    required this.articleTitle,
    required this.articleDescription,
    required this.authorName,
    required this.publishDate,
    required this.articleid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Header مع الصورة
          SliverAppBar(
            expandedHeight: 300,
            stretch: true,
            flexibleSpace: _buildArticleHeader(),
            backgroundColor: Colors.white,
            elevation: 0,
            pinned: true,
            leading: _buildBackButton(context),
            actions: [_buildActionButtons(context)],
          ),

          // محتوى المقال
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24),

                  // العنوان
                  _buildArticleTitle(),

                  SizedBox(height: 24),

                  // معلومات الكاتب
                  _buildAuthorSection(),

                  SizedBox(height: 32),

                  // الوصف
                  _buildArticleDescription(),

                  SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildArticleHeader() {
    return FlexibleSpaceBar(
      stretchModes: [StretchMode.zoomBackground],
      background: Stack(
        fit: StackFit.expand,
        children: [
          // صورة المقال
          CachedNetworkImage(
            imageUrl: articleImage,
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

          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.4),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return IconButton(
      icon: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.arrow_back, color: Colors.black, size: 20),
      ),
      onPressed: () => Navigator.pop(context),
    );
  }

  Widget _buildActionButtons(context) {
    return Row(
      children: [
        IconButton(
          icon: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.bookmark_border, color: Colors.black, size: 20),
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.share, color: Colors.black, size: 20),
          ),
          onPressed: () {



          },
        ),

        IconButton(
          icon: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.insert_comment_outlined, color: Colors.black, size: 20),
          ),
          onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CommentsPage(articleId: articleid),));


          },
        ),

      ],
    );
  }

  Widget _buildArticleTitle() {
    return Text(
      articleTitle,
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        height: 1.3,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildAuthorSection() {
    return Row(
      children: [
        // صورة الكاتب
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.blue[100],
          child: Icon(Icons.person, color: Colors.blue[600], size: 18),
        ),

        SizedBox(width: 12),

        // معلومات الكاتب
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                authorName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4),
              Text(
                publishDate,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildArticleDescription() {
    return Text(
      articleDescription,
      style: TextStyle(
        fontSize: 18,
        height: 1.6,
        color: Colors.grey[800],
      ),
    );
  }
}