import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommentActions extends StatelessWidget {
  final int likes;
  final int dislikes;
  final VoidCallback onLike;
  final VoidCallback onDislike;
  final VoidCallback onReply;
  final VoidCallback onMore;
  final name;

  CommentActions({
    Key? key,
    required this.likes,
    required this.dislikes,
    required this.onLike,
    required this.onDislike,
    required this.onReply,
    required this.onMore,
    this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Row(
      children: [
        _buildActionButton(
          Icons.thumb_up_alt_outlined,
          likes > 0 ? _formatCount(likes) : null,
          onLike,
          context,
        ),
        SizedBox(width: 16),
        _buildActionButton(
          Icons.thumb_down_alt_outlined,
          dislikes > 0 ? _formatCount(dislikes) : null,
          onDislike,
          context,
        ),
        SizedBox(width: 16),
        _buildActionButton(
          Icons.reply_outlined,
          '',
          onReply,
          context,
        ),
        Spacer(),
        user != name
            ? _buildActionButton(
          Icons.more_vert,
          null,
          onMore,
          context,
        )
            : Container(),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String? text, VoidCallback onTap, BuildContext context) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18, color: Colors.grey[700]),
      label: text != null && text.isNotEmpty
          ? Text(
        text,
        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
      )
          : SizedBox.shrink(),
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: Size.zero,
      ),
    );
  }

  String _formatCount(int count) {
    if (count < 1000) return count.toString();
    if (count < 1000000) return '${(count / 1000).toStringAsFixed(1)}K';
    return '${(count / 1000000).toStringAsFixed(1)}M';
  }
}