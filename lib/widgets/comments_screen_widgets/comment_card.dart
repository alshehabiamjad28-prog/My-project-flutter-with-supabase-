import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'comment_actions.dart';

class CommentCard extends StatelessWidget {
  final Map<String, dynamic> comment;
  final VoidCallback onReply;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isCurrentUser;

  const CommentCard({
    Key? key,
    required this.comment,
    required this.onReply,
    required this.onEdit,
    required this.onDelete,
    required this.isCurrentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[300],
            backgroundImage: comment['user_avatar'] != null
                ? NetworkImage(comment['user_avatar']!)
                : null,
            child: comment['user_avatar'] == null
                ? Icon(
              Icons.person,
              size: 20,
              color: Colors.grey,
            )
                : null,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment['user_name'] ?? 'User',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      _formatTime(comment['created_at']),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  comment['content'] ?? '',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.4,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 12),
                CommentActions(
                  name: comment['user_name'],
                  likes: comment['likes_count'] ?? 0,
                  dislikes: comment['dislikes_count'] ?? 0,
                  onLike: () => _handleLike(),
                  onDislike: () => _handleDislike(),
                  onReply: onReply,
                  onMore: () => _showMoreOptions(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleLike() {
    // TODO: تنفيذ الإعجاب
  }

  void _handleDislike() {
    // TODO: تنفيذ عدم الإعجاب
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isCurrentUser) ...[
                _buildOptionItem(Icons.edit, 'Update', onEdit, context),
                _buildOptionItem(Icons.delete, 'Delete', onDelete, context),
              ],
              _buildOptionItem(Icons.flag, 'Report', () {
                Navigator.pop(context);
              }, context),
              _buildOptionItem(Icons.copy, 'Copy', () {
                Clipboard.setData(ClipboardData(text: comment['content']));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Copied to clipboard')),
                );
              }, context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionItem(IconData icon, String text, VoidCallback onTap, BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 22),
      title: Text(text),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  String _formatTime(String? dateString) {
    if (dateString == null) return 'Now';
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inMinutes < 1) return 'Now';
      if (difference.inMinutes < 60) return '${difference.inMinutes}m';
      if (difference.inHours < 24) return '${difference.inHours}h';
      if (difference.inDays < 7) return '${difference.inDays}d';
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Now';
    }
  }
}