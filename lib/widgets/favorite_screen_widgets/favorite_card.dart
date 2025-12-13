// import 'package:fire/services/articles_service.dart';
// import 'package:flutter/material.dart';
//
// class FavoriteCard extends StatelessWidget {
//   final Map<String, dynamic> article;
//   final VoidCallback onTap;
//   final VoidCallback onDelete;
//   final bool isLoading;
//   final bool isDeleting;
//
//   const FavoriteCard({
//     Key? key,
//     required this.article,
//     required this.onTap,
//     required this.onDelete,
//     required this.isLoading,
//     required this.isDeleting,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 8,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(12),
//           onTap: onTap,
//           child: Padding(
//             padding: EdgeInsets.all(16),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // صورة المقال
//                 _buildArticleImage(),
//
//                 SizedBox(width: 12),
//
//                 // محتوى المقال
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // العنوان
//                       Text(
//                         article['title']?.toString() ?? 'بدون عنوان',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           height: 1.4,
//                           color: Colors.black87,
//                         ),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//
//                       SizedBox(height: 8),
//
//                       // الوصف
//                       Text(
//                         article['content']?.toString() ?? '',
//                         style: TextStyle(
//                           fontSize: 14,
//                           height: 1.5,
//                           color: Colors.grey[600],
//                         ),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//
//                       SizedBox(height: 12),
//
//                       // معلومات إضافية
//                       _buildArticleInfo(),
//                     ],
//                   ),
//                 ),
//
//                 // زر الحذف
//                 _buildDeleteButton(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildArticleImage() {
//     return Container(
//       width: 80,
//       height: 80,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         color: Colors.grey[200],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(8),
//         child: Image.network(
//          ArticlesService().getImageUrl(i)
//           fit: BoxFit.cover,
//           errorBuilder: (context, error, stackTrace) {
//             return Icon(
//               Icons.article,
//               size: 30,
//               color: Colors.grey[400],
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildArticleInfo() {
//     return Row(
//       children: [
//         // المؤلف
//         Icon(Icons.person_outline, size: 14, color: Colors.grey[500]),
//         SizedBox(width: 4),
//         Expanded(
//           child: Text(
//             article['author_name']?.toString() ?? 'Amjad alshehabi',
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.grey[500],
//             ),
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//
//         SizedBox(width: 12),
//
//         // التاريخ
//         Icon(Icons.calendar_today, size: 14, color: Colors.grey[500]),
//         SizedBox(width: 4),
//         Text(
//           _formatDate(article['created_at']?.toString() ?? ''),
//           style: TextStyle(
//             fontSize: 12,
//             color: Colors.grey[500],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildDeleteButton() {
//     return IconButton(
//       onPressed: isLoading ? null : onDelete,
//       icon: isDeleting
//           ? SizedBox(
//         width: 20,
//         height: 20,
//         child: CircularProgressIndicator(strokeWidth: 2),
//       )
//           : Icon(
//         Icons.favorite,
//         color: Colors.red,
//         size: 24,
//       ),
//     );
//   }
//
//   String _formatDate(String dateString) {
//     try {
//       final date = DateTime.parse(dateString);
//       return '${date.day}/${date.month}/${date.year}';
//     } catch (e) {
//       return 'تاريخ غير معروف';
//     }
//   }
// }