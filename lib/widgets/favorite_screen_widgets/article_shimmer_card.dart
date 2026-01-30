import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SimpleArticleShimmer extends StatelessWidget {
  const SimpleArticleShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // العنوان
            Container(
              width: double.infinity,
              height: 24,
              color: Colors.white,
            ),
            const SizedBox(height: 16),

            // النصوص
            Container(
              width: double.infinity,
              height: 16,
              color: Colors.white,
            ),
            const SizedBox(height: 8),

            Container(
              width: double.infinity,
              height: 16,
              color: Colors.white,
            ),
            const SizedBox(height: 8),

            Container(
              width: 180,
              height: 16,
              color: Colors.white,
            ),
            const SizedBox(height: 24),

            // الصف السفلي
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100,
                      height: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 6),

                    Container(
                      width: 70,
                      height: 14,
                      color: Colors.white,
                    ),
                  ],
                ),

                const Spacer(),

                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}