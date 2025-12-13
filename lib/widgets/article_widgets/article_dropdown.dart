import 'package:flutter/material.dart';

class CustomDropdownFormField extends StatefulWidget {
  final TextEditingController controller;
  final List<String> items;
  final String hintText;
  final String otherOptionText;

  const CustomDropdownFormField({
    Key? key,
    required this.controller,
    required this.items,
    required this.hintText,
    this.otherOptionText = "أخرى",
  }) : super(key: key);

  @override
  _CustomDropdownFormFieldState createState() =>
      _CustomDropdownFormFieldState();
}

class _CustomDropdownFormFieldState extends State<CustomDropdownFormField> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  List<String> _filteredItems = [];
  bool _isMenuOpen = false;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;

    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 5),
          child: Material(
            elevation: 4,
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              constraints: BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _filteredItems.length + 1,
                itemBuilder: (context, index) {
                  if (index == _filteredItems.length) {
                    return ListTile(
                      title: Text(widget.otherOptionText),
                      onTap: () {
                        widget.controller.clear();
                        _hideOverlay();
                      },
                    );
                  }
                  return ListTile(
                    title: Text(_filteredItems[index]),
                    onTap: () {
                      widget.controller.text = _filteredItems[index];
                      _hideOverlay();
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isMenuOpen = true);
  }

  void _hideOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
    setState(() => _isMenuOpen = false);
  }

  void _filterList(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });

    if (!_isMenuOpen && query.isNotEmpty) {
      _showOverlay();
    }
  }

  @override
  void dispose() {
    _hideOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    border: InputBorder.none,
                    isCollapsed: true,
                  ),
                  onChanged: _filterList,
                  onTap: () {
                    if (!_isMenuOpen) {
                      _showOverlay();
                    }
                  },
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (_isMenuOpen) {
                    _hideOverlay();
                  } else {
                    _showOverlay();
                  }
                },
                child: Icon(
                  _isMenuOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
