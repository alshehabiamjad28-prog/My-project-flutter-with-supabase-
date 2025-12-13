import 'package:fire/style.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagePickerWidget extends StatefulWidget {
  final File? imageFile;
  final Function(File) onImageSelected;
  final double? width;
  final double? height;

  const ImagePickerWidget({
    Key? key,
    this.imageFile,
    required this.onImageSelected,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1080,
        maxHeight: 1080,
      );

      if (pickedFile != null) {
        widget.onImageSelected(File(pickedFile.path));
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: widget.width ?? double.infinity,
        height: widget.height ?? 140,
        padding: const EdgeInsets.all(0), // إزالة البادنج الداخلي
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFD1D5DB)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: widget.imageFile != null && widget.imageFile!.path.isNotEmpty
            ? ClipRRect(
          borderRadius: BorderRadius.circular(8), // نفس زوايا الكونتينر
          child: Image.file(
            widget.imageFile!,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.fill, // يملأ الكونتينر كاملاً
            errorBuilder: (context, error, stackTrace) {
              return _buildPlaceholder();
            },
          ),
        )
            : _buildPlaceholder(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.camera_alt_outlined,
          color: Color(0xFF6B7280),
          size: 32,
        ),
        SizedBox(height: 8),
        Text(
          'Choose Image',
          style: TextStyle(
            color: Color(0xFF374151),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}