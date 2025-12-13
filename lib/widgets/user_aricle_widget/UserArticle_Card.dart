
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fire/widgets/Icon_button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../style.dart';

class UserarticleCard extends StatelessWidget {
  final Function()? deletonPressed;

  final Function()? updateonPressed;

  final String? imageUrl;
  final String? title;
  final String? authorName;
  final String? publishDate;
  final VoidCallback? onTap;

  const UserarticleCard({
    super.key,
    this.imageUrl,
    this.title,
    this.authorName,
    this.publishDate,
    this.onTap,
    this.deletonPressed,
    this.updateonPressed,
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    final double cardWidth = screenSize.width > 400
        ? 300
        : screenSize.width * 0.9;
    final double cardHeight = 300;
    final double imageHeight = 160;

    return Padding(
      padding: EdgeInsets.only(left: 2, right: 2, bottom: 50),
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
                bottom: BorderSide(color: Colors.black87),
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

                Row(
                  children: [
                    // محتوى النصوص
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // العنوان - سطر واحد مع نقاط
                            if (title != null) const SizedBox(height: 15),
                            Container(

                              child: Text(
                                title!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF111827),
                                  height: 1.3,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              width: 300,
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

                    // الأزرار - بدون Padding كبير
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10), // ✅ مسافة صغيرة ثابتة
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconbuttonWidget(
                            icon: Icon(
                              CupertinoIcons.pen,
                              color: secondaryButtonColor,
                              size: screenSize.width * 0.035, // ✅ حجم نسبي
                            ),
                            onPressed: updateonPressed,
                          ),
                          SizedBox(height: 10),
                          IconbuttonWidget(
                            icon: Icon(
                              CupertinoIcons.delete_left,
                              color: secondaryButtonColor,
                              size: screenSize.width * 0.035, // ✅ حجم نسبي
                            ),
                            onPressed: deletonPressed,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // الدالة الذكية الاحترافية

  Widget _buildSmartImage({
    required String? imageUrl,
    double? width,
    double? height,
    BorderRadiusGeometry borderRadius = BorderRadius.zero,
    BoxFit fit = BoxFit.fill,
  }) {
    return Container(
      width: width ?? double.infinity,
      height: 187,
      decoration: BoxDecoration(
        color: Colors.red[200],
        borderRadius: borderRadius,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? CachedNetworkImage(
          imageUrl: imageUrl!, // 🔥 استخدام imageUrl مباشرة بدون ArticlesService
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
