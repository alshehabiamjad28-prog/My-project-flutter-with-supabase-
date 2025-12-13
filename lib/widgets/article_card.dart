import 'package:cached_network_image/cached_network_image.dart';

import 'package:fire/style.dart';
import 'package:flutter/material.dart';

class ArticleCard extends StatelessWidget {
  final String? imageUrl;
  final String? title;
  final String? authorName;
  final String? publishDate;
  final VoidCallback? onTap;
  final Function()? onPressedl;

  const ArticleCard({
    super.key,
    this.imageUrl,
    this.title,
    this.authorName,
    this.publishDate,
    this.onTap,
    this.onPressedl,
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final size = MediaQuery.of(context).size;

    final double cardWidth = screenSize.width > 400
        ? 300
        : screenSize.width * 0.9;
    final double cardHeight = 300;
    final double imageHeight = 160;

    return Padding(
      padding: EdgeInsets.only(left: 2, right: 2, bottom: 25),
      child: SizedBox(
        width: cardWidth * 2,
        height: cardHeight,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              // borderRadius: BorderRadius.circular(12),
              border: BoxBorder.fromLTRB(
                bottom: BorderSide(color: Colors.black87.withOpacity(0.2)),
              ),
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.black.withOpacity(0.1),
              //     blurRadius: 8,
              //     offset: const Offset(0, 2),
              //   ),
              // ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // صورة المقال بالدالة الذكية
                _buildSmartImage(
                  imageUrl: imageUrl,
                  height: imageHeight,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),

                SingleChildScrollView(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // العنوان - سطر واحد مع نقاط
                              if (title != null) const SizedBox(height: 13),
                              Container(
                                width: 300,
                                child: Text(
                                  title!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF111827),
                                    height: 1.9,
                  
                  
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                  
                                ),
                              ),
                  
                              // المؤلف والتاريخ - سطر واحد مع نقاط
                              if (authorName != null || publishDate != null) ...[
                                const SizedBox(height: 33),
                                Container(
                                  width: 230,
                                  child: Row(
                                    children: [
                                      // المؤلف - بعرض ثابت
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          child: Text(
                                            authorName!,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF6B7280),
                                              fontWeight: FontWeight.w500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ),
                  
                                      // مسافة بين المؤلف والتاريخ
                                      const SizedBox(width: 10),
                  
                                      // التاريخ - بعرض ثابت
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          child: Text(
                                            publishDate!,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF6B7280),
                                              fontWeight: FontWeight.w500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                  
                      Container(

                        margin: const EdgeInsets.only(top: 60, right: 1),
                        // ✅ إصلاح هنا
                        height: 40,
                        alignment: Alignment.centerRight,
                        // ✅ محاذاة لليمين بدلاً من bottomLeft
                        child: IconButton(
                          icon: SizedBox(
                            height: 20,
                            width: 20,
                            child: Icon(
                              Icons.favorite_border,
                              color: Colors.black,
                              size: 23
                            ),
                          ),
                          onPressed: onPressedl,
                        ),

                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSmartImage({
    required String? imageUrl,
    double? width,
    double? height,
    BorderRadiusGeometry borderRadius = BorderRadius.zero,
    BoxFit fit = BoxFit.fill,
  }) {
    return Container(
      width: width ?? double.infinity,
      height: 190,
      decoration: BoxDecoration(
        color: Colors.red[200],
        borderRadius: borderRadius,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                // 🔥 استخدام imageUrl مباشرة بدون ArticlesService
                fit: fit,
                width: double.infinity,
                height: height ?? 200,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.grey[400]!,
                      ),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) {
                  print('❌ خطأ في الصورة: $error');
                  print('🔗 الرابط: $url');
                  return Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: Icon(
                        Icons.article,
                        size: 40,
                        color: Colors.grey[400],
                      ),
                    ),
                  );
                },
              )
            : Container(
                color: Colors.grey[200],
                child: Center(
                  child: Icon(Icons.article, size: 40, color: Colors.grey[400]),
                ),
              ),
      ),
    );
  }

  String _buildAuthorText() {
    if (authorName != null && publishDate != null) {
      return '$authorName • $publishDate';
    } else if (authorName != null) {
      return authorName!;
    } else if (publishDate != null) {
      return publishDate!;
    }
    return '';
  }
}
