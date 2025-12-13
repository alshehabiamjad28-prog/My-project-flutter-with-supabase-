import 'package:flutter/material.dart';

class AddCommentSection extends StatefulWidget {
  final Function(String) onCommentAdded;
  final String? replyTo;

  const AddCommentSection({
    Key? key,
    required this.onCommentAdded,
    this.replyTo,
  }) : super(key: key);

  @override
  State<AddCommentSection> createState() => _AddCommentSectionState();
}

class _AddCommentSectionState extends State<AddCommentSection> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[300],
            child: Icon(
              Icons.person,
              size: 20,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: widget.replyTo != null ? 'Add reply...' : 'Add comment...',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[400]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue[700]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
            ),
          ),
          SizedBox(width: 12),
          ElevatedButton(
            onPressed: _isLoading || _controller.text.isEmpty ? null : _submitComment,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: _isLoading
                ? SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
                : Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _submitComment() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() => _isLoading = true);

    try {
      await widget.onCommentAdded(_controller.text.trim());
      _controller.clear();
      setState(() {

      });
    } catch (e) {
      // معالجة الخطأ
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}