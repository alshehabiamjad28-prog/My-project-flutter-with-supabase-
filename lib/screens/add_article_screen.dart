import 'dart:io';


import 'package:fire/widgets/elevated_button.dart';
import 'package:fire/widgets/Text_widget.dart';
import 'package:flutter/material.dart';

import '../services/articles_service.dart';
import '../style.dart';
import '../utils/validators.dart';
import '../widgets/article_widgets/Article_Dropdown.dart';
import '../widgets/article_widgets/Article_textfield_content.dart';
import '../widgets/article_widgets/Article_textfield_title.dart';
import '../widgets/article_widgets/Imagepicker_widget.dart';
import 'home_screen.dart' show Homescreen;
import 'listpages_screen.dart';

class Addarticlescreen extends StatefulWidget {

  const Addarticlescreen({super.key});

  @override
  State<Addarticlescreen> createState() => _AddarticlescreenState();
}

class _AddarticlescreenState extends State<Addarticlescreen> {
  bool loding=false;

  TextEditingController Title = TextEditingController();
  TextEditingController Content = TextEditingController();
  TextEditingController Category = TextEditingController();
  GlobalKey<FormState> form = GlobalKey();
  File? _selectedImage;

  final List<String> categories = [
    "News",
    "Literature & Poetry",
    "Tools",
    "Fashion",
    "Cybersecurity",
    "Economy",
    "Discoveries",
    "Productivity",
    "Inventions",
    "Investment",
    "Meetings",
    "Radio",
    "Family",
    "Home Economics",
    "Clothing",
    "Electronics",
    "Security",
    "Internet",
    "Software",
    "Programming",
    "Research",
    "Construction",
    "Stock Market",
    "Environment",
    "History",
    "Analytics",
    "Entertainment",
    "Marketing",
    "Digital Marketing",
    "Anatomy",
    "Design",
    "Interior Design",
    "Photography",
    "Applications",
    "Self Development",
    "Education",
    "Teaching & Learning",
    "Nutrition",
    "Technology",
    "Technology & Programming",
    "Acting",
    "Schedule",
    "Surgery",
    "Geography",
    "Conversation",
    "Artificial Intelligence",
    "Memories",
    "Novels",
    "Sports",
    "Mathematics",
    "Agriculture",
    "Swimming",
    "Cars",
    "Tourism",
    "Politics",
    "Cinema",
    "Companies",
    "Poetry",
    "Health",
    "Mental Health",
    "Medicine",
    "Cooking",
    "Nature",
    "Weather",
    "Energy",
    "Children",
    "Phenomena",
    "Family",
    "Relationships",
    "Science",
    "Science & Nature",
    "Philosophy",
    "Arts",
    "Video",
    "Astronomy",
    "Space",
    "Reading",
    "Short Stories",
    "Leadership",
    "Comedy",
    "Languages",
    "Society",
    "Accounting",
    "Reviews",
    "Farms",
    "Series",
    "Beverages",
    "Restaurants",
    "Comparisons",
    "Music",
    "Stars",
    "Plants",
    "Tips",
    "Engineering",
    "Time",
    "Recipes",
    "Yoga",
    "Weight Loss",
    "Programming",
    "Mobile Applications",
    "Web Development",
    "Exercises",
    "Development",
    "Animals",
    "Studies",
    "Decor",
    "Sports",
    "Sports",
    "Mathematics",
    "Agriculture",
    "Cars",
    "Poetry",
    "Health",
    "Medicine",
    "Cooking",
    "Nature",
    "Real Estate",
    "Art",
    "Arts",
    "Story",
    "Football",
    "Bodybuilding",
    "Languages",
    "Restaurants",
    "Music",
    "Plants",
    "Hobbies",
    "Social Media",
    "Yoga",
  ];

  validators() async {
    if (form.currentState!.validate()) {
      try {
        setState(() => loding = true);

        final success = await ArticlesService().createArticle(
          title: Title.text,
          content: Content.text,
          category: Category.text,
          urlimage: await ArticlesService().uploadImage(_selectedImage!),
        );

        setState(() => loding = false);

        if (success) {
          // ⭐ 1. الانتقال أولاً مباشرة
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => PageList()),
            );
          }

          // ⭐ 2. عرض الإشعار في الصفحة الجديدة (في PageList)
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Failed to create article")),
            );
          }
        }
      } catch (e) {
        setState(() => loding = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(" An error occurred: $e")),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please check the entered data")),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,

        title: const Text(
          'Add New Article',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.only(left: 35.0, right: 50.0, top: 30.0),

          child: Form(
            key: form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               ?loding != true ? null : Center(child: CircularProgressIndicator(color: Colors.blue,),),
                // Article Title Section
                TextWidget(title: "Article Title"),
                const SizedBox(height: 8),
                ArticleTextfieldTitle(
                  controller: Title,
                  valdator: validateTitle,
                ),
                const SizedBox(height: 20),

                // Article Content Section
                TextWidget(title: "Article Content"),

                const SizedBox(height: 8),
                ArticleTextfieldContent(
                  controller: Content,
                  valdator: validateContent,
                ),

                const SizedBox(height: 20),

                ImagePickerWidget(
                  imageFile: _selectedImage, // إرسال المتغير
                  onImageSelected: (File newImage) {
                    setState(() {
                      _selectedImage =
                          newImage; // تحديث المتغير عند اختيار صورة
                    });
                  },
                ),

                const SizedBox(height: 20),

                // Select Category Section
                TextWidget(title: "Select Category"),

                const SizedBox(height: 8),
                CustomDropdownFormField(
                  controller: Category,
                  items: categories,
                  hintText: "Select Category",
                ),

                const SizedBox(height: 30),
                Center(
                  child: Elevatedbutton(
                    onPressed: () async {
                      validators();
                    },
                    title: "Push",
                  ),
                ),

                // Publish Button
                SizedBox(height: 25),

                // Hint Text
                Center(
                  child: Text(
                    'You can add an image to enhance your article.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF6B7280), fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
