import 'package:fire/style.dart';
import 'package:fire/utils/validators.dart';
import 'package:fire/widgets/Reply_Widgets/reply_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/replies_service.dart';
import '../widgets/Reply_Widgets/reply_button.dart';
import '../widgets/Reply_Widgets/reply_Text_field.dart';
import '../widgets/comments_screen_widgets/update_Comment_dialog.dart';

class Replycomment extends StatefulWidget {
  final commentid;

  const Replycomment({super.key, this.commentid});

  @override
  State<Replycomment> createState() => _ReplycommentState();
}

class _ReplycommentState extends State<Replycomment> {
  TextEditingController content = TextEditingController();
  TextEditingController Update = TextEditingController();

  TextEditingController yy = TextEditingController();

  InsertReply() async {
    try {
      final reply = await RepliesService().InsertReply(
        content.text,
        widget.commentid['id'].toString(),
      );
      if (reply) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(" comments added successfully"),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
            ),
          );

          setState(() {});
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


  UpdatecComment(String commenID, String content) async {
    try {
      final comment = await RepliesService().updateComment(
          content,
          commenID
      );
      if (comment) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(" comments Udate successfully"),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
            ),
          );

          setState(() {});
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

  DeletComment(String commenID) async {
    try {
      final comment = await RepliesService().Deletcomment(
        commenID,
      );
      if (comment) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(" comments Delet successfully"),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
            ),
          );

          setState(() {});
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
    var width = MediaQuery
        .of(context)
        .size
        .width;
    var height = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(backgroundColor: backgroundColor),
      body: Padding(
        padding: EdgeInsetsGeometry.only(),

        child: Column(
          children: [
            Center(
              child: Container(
                height: height * 0.1,
                padding: EdgeInsets.only(top: 20, right: 20, left: 20),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  border: Border(top: BorderSide(color: backgroundColor)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ReplyTextField(
                        hint: "Add reply...",
                        controller: content,
                        validator: validateTitle,
                      ),
                    ),
                    SizedBox(width: 12),
                    ReplyButton(
                      text: "Add",
                      onPressed: () {
                        InsertReply();
                      },
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 10),
            CommentWidget(
              comment: "",
              userName: widget.commentid['username']?.toString() ?? '',
              commentText: widget.commentid['content']?.toString() ?? '',
              onLike: () {},
              onDislike: () {},
              onReply: () {},
              onMore: () {},
              OnUpdate: (context) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("تم فتح التعديل"),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              OnReport: (context) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("تم الإبلاغ"),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              OnDelet: (context) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("تم الحذف"),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              OnCopy: (context) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("تم النسخ"),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),

            SizedBox(height: 30),
            Expanded(
              child: Padding(
                padding: EdgeInsetsGeometry.only(),

                child: SingleChildScrollView(
                  child: StreamBuilder(
                    stream: RepliesService().getReplies(
                      widget.commentid['id'].toString(),
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        print('❌ خطأ في Stream: ${snapshot.error}');
                        print('📊 بيانات الخطأ: ${snapshot.stackTrace}');
                        return _buildErrorState();
                      }

                      // حالة عدم وجود بيانات
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        print('📭 لا توجد بيانات أو القائمة فارغة');
                        return Center(child: Text("No comments found"));
                      }

                      // حالة النجاح - عرض المقالات
                      final rplies = snapshot.data!;
                      print('✅ عدد المقالات المستلمة: ${rplies.length}');

                      return Container(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            // ✅ التصحيح هنا
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: rplies.length,
                              itemBuilder: (context, index) {
                                final reply = rplies[index];
                                return CommentWidget(
                                  comment: reply,
                                  userName: reply['username']?.toString() ?? '',
                                  commentText:
                                  reply['content']?.toString() ?? '',
                                  onLike: () {},
                                  onDislike: () {},
                                  onReply: () {},
                                  onMore: () {},
                                  OnUpdate: (context) {
                                    Navigator.pop(context);
                                    // ✅ الصحيح
                                    showDialog(
                                      context: context,
                                      // يجب أن يكون context صالح
                                      builder: (context) =>
                                          UpdateDialog(
                                            hint: "Update comment",
                                            validator: validateTitle,
                                            onCancel: () {
                                              Navigator.pop(context);
                                            },
                                            controller: Update,
                                            onPressed: () {
                                              UpdatecComment(
                                                  reply['id']?.toString() ?? '',
                                                  Update.text);
                                              Navigator.pop(context);
                                              print(Update.text);
                                              print(reply['id']?.toString() ??
                                                  '');
                                            },
                                          ),
                                    );
                                  },
                                  OnReport: (context) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("تم الإبلاغ"),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                  OnDelet: (context) {
                                    Navigator.pop(context);
                                    showDialog(
                                      context: context, builder: (context) =>
                                        AlertDialog(

                                          title: Text('Delete comment',
                                            style: TextStyle(fontSize: 16),),
                                          content: Text('Are you sure?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, false),
                                              child: Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                DeletComment(
                                                    reply['id']?.toString() ??
                                                        '');
                                                Navigator.pop(context);
                                                setState(() {

                                                });
                                              },
                                              child: Text('Confirm'),
                                            ),
                                          ],
                                        ),);
                                  },
                                  OnCopy: (context) {
                                    Navigator.pop(context);
                                    Clipboard.setData(
                                        ClipboardData(text: reply['content']));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("تم النسخ"),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'Error loading comments',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => setState(() {}),
            child: Text(
              ' Reload'
                  '+',
            ),
          ),
        ],
      ),
    );
  }
}
