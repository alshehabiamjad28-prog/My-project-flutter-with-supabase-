import 'package:fire/widgets/Reply_Widgets/Interaction_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReplyShowmodalbottomsheet extends StatelessWidget {
  final user = Supabase.instance.client.auth.currentUser;
  final comment;
  final void Function(BuildContext) OnUpdate;
  final void Function(BuildContext) OnDelet;
  final void Function(BuildContext) OnReport;
  final void Function(BuildContext) OnCopy;

  ReplyShowmodalbottomsheet({
    super.key,
    required this.OnUpdate,
    required this.OnDelet,
    required this.OnReport,
    required this.OnCopy,
    this.comment
  });

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return InteractionButton(
      icon: Icons.more_vert_outlined,
      text: '',
      onPressed: () {
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setState) {
                final isCurrentUser = user!.id == comment['user_id'];

                return Container(
                  width: width,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      if (isCurrentUser) ...[
                        InteractionButton(
                          icon: CupertinoIcons.pen,
                          text: "Update",
                          onPressed: () => OnUpdate(context),
                        ),
                        SizedBox(height: height * 0.02),
                        InteractionButton(
                          icon: Icons.delete,
                          text: "Delet",
                          onPressed: () => OnDelet(context),
                        ),
                        SizedBox(height: height * 0.02),
                      ],

                      // الأزرار العامة (تظهر للجميع)
                      InteractionButton(
                        icon: Icons.report_gmailerrorred,
                        text: "Report",
                        onPressed: () => OnReport(context),
                      ),
                      SizedBox(height: height * 0.02),
                      InteractionButton(
                        icon: Icons.copy,
                        text: "Copy",
                        onPressed: () => OnCopy(context),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}