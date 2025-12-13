import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/comments_service.dart';
import '../utils/validators.dart';

import '../widgets/comments_screen_widgets/add_comment_section.dart';
import '../widgets/comments_screen_widgets/comment_card.dart';
import '../widgets/comments_screen_widgets/update_Comment_dialog.dart';
import 'reply_comments_screen.dart';

class CommentsPage extends StatefulWidget {
  final String articleId;

  const CommentsPage({Key? key, required this.articleId}) : super(key: key);

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  TextEditingController text = TextEditingController();
  final CommentsService _commentsService = CommentsService();
  final ScrollController _scrollController = ScrollController();
  final user = Supabase.instance.client.auth.currentUser;

  Updatecomment(String commentId) async {
    try {
      final comment = await CommentsService().updateComment(
          text: text.text,
          commentId: commentId);
      if (comment) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Comment updated successfully"),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
            ),
          );
          Navigator.of(context).pop();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("An error occurred"),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: Column(
        children: [

          AddCommentSection(onCommentAdded: _addComment),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: _buildCommentsList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'Comments',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black87),
      centerTitle: true,
    );
  }

  Widget _buildCommentsList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _commentsService.getArticleComments(widget.articleId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState(context);
        }
        if (snapshot.hasError) {
          return _buildErrorState(context);
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyState(context);
        }
        final comments = snapshot.data!;
        return _buildCommentsListView(comments);
      },
    );
  }

  Widget _buildCommentsListView(List<Map<String, dynamic>> comments) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      controller: _scrollController,
      padding: EdgeInsets.zero,
      itemCount: comments.length,
      itemBuilder: (context, index) {
        final comment = comments[index];
        return CommentCard(
          comment: comment,
          onReply: () => _handleReply(comment),
          onEdit: () => _handleEdit(comment),
          onDelete: () => _handleDelete(comment),
          isCurrentUser: _isCurrentUserComment(comment),
        );
      },
    );
  }

  Future<void> _addComment(String text) async {
    final success = await _commentsService.addComment(
      text: text,
      articleId: widget.articleId,
    );
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Comment added'),
          backgroundColor: Colors.green[700],
        ),
      );
    }
  }

  void _handleReply(Map<String, dynamic> comment) async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Replycomment(commentid: comment)
    ));
  }

  void _handleEdit(Map<String, dynamic> comment) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) =>
          UpdateDialog(
            hint: "Update comment",
            controller: text,
            validator: validateTitle,
            onCancel: () {
              Navigator.of(context).pop();
            },
            onPressed: () async {
              Updatecomment(comment['id'].toString());
            },
          ),
    );
  }

  Future<void> _handleDelete(Map<String, dynamic> comment) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text('Delete comment'),
            content: Text('Are you sure?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Confirm'),
              ),
            ],
          ),
    );
    if (confirmed == true) {
      final success = await _commentsService.removeComment(
        commentId: comment['id']?.toString()??'',
      );
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Comment deleted'),
            backgroundColor: Colors.red[700],
          ),
        );
      }
    }
  }

  bool _isCurrentUserComment(Map<String, dynamic> comment) {
    final currentUser = Supabase.instance.client.auth.currentUser;
    return comment['user_id'] == currentUser?.id;
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 60,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'An error occurred while loading comments',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => setState(() {}),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              foregroundColor: Colors.white,
            ),
            child: Text('Try again'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: Colors.grey[300],
          ),
          SizedBox(height: 16),
          Text(
            'No comments yet',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            'Be the first to comment',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}