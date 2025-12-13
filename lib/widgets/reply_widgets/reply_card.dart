import 'package:fire/widgets/Reply_Widgets/reply_show_model_bottom_Sheet.dart';
import 'package:flutter/material.dart';
import 'Interaction_button.dart';

class CommentWidget extends StatelessWidget {
  final String userName;
  final String commentText;
  final VoidCallback onLike;
  final VoidCallback onDislike;
  final VoidCallback onReply;
  final VoidCallback onMore;
  final int? likeCount;
  final int? dislikeCount;
  final int? replyCount;
  final void Function(BuildContext) OnDelet; // غير إلى BuildContext
  final void Function(BuildContext) OnCopy;  // غير إلى BuildContext
  final void Function(BuildContext) OnUpdate; // غير إلى BuildContext
  final void Function(BuildContext) OnReport; // غير إلى BuildContext
final comment;
  const CommentWidget({

    super.key,
    required this.userName,
    required this.commentText,
    required this.onLike,
    required this.onDislike,
    required this.onReply,
    required this.onMore,
    this.likeCount,
    this.dislikeCount,
    this.replyCount,
    required this.OnDelet,
    required this.OnCopy,
    required this.OnUpdate,
    required this.OnReport, this.comment,
  });

  @override
  Widget build(BuildContext context) {
    var textsize = TextScaler.linear(MediaQuery.of(context).textScaleFactor);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: width * 0.40,
            child: Text(
              overflow: TextOverflow.ellipsis,
              textScaler: textsize,
              userName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.black87,
              ),
            ),
          ),

          SizedBox(height: 8),

          Text(
            maxLines: 3,
            textScaler: textsize,
            commentText,
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),

          SizedBox(height: 12),

          Row(
            children: [
              InteractionButton(
                icon: Icons.thumb_up_alt_outlined,
                text: "",
                onPressed: onLike,
                count: likeCount,
              ),

              SizedBox(width: width * 0.02), // استبدل spacing بـ SizedBox

              InteractionButton(
                icon: Icons.thumb_down_alt_outlined,
                text: "",
                onPressed: onDislike,
                count: dislikeCount,
              ),

              SizedBox(width: width * 0.02),

              InteractionButton(
                icon: Icons.reply_outlined,
                text: "",
                onPressed: onReply,
                count: replyCount,
              ),

              Spacer(),

              ReplyShowmodalbottomsheet(
                comment: comment,
                OnCopy: OnCopy, // ✅ تمرير مباشرة بعد التصحيح
                OnDelet: OnDelet,
                OnReport: OnReport,
                OnUpdate: OnUpdate,
              ),
            ],
          ),
        ],
      ),
    );
  }
}