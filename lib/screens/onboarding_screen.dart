import 'package:concentric_transition/page_view.dart' show ConcentricPageView;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:myproject/screens/home_screen.dart';
import '../models/OnboardingItem_Model.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onFinish; // سيتم تمرير الدالة للانتقال للصفحة الرئيسية

  const OnboardingScreen({super.key, required this.onFinish});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _controller;
  final List<PageModel> pages = [];

  @override
  void initState() {
    super.initState();
    _controller = PageController();

    pages.addAll([
      PageModel(

        Image.asset('images/1765138379745.jpg', fit: BoxFit.cover),
        title: "Curated Articles",
        subtitle: "Discover handpicked stories and deep insights.",
        textColor: Colors.black87,
        icon: Icons.menu_book_rounded,
        bgColor: Colors.white
      ),
      PageModel(
        Image.asset('images/1765138618830.jpg', fit: BoxFit.cover),
        title: "Smooth Reading",
        subtitle: "A clean, distraction-free reader for long content.",
        bgColor: Colors.white,
        textColor: Colors.black87,
        icon: Icons.chrome_reader_mode,
      ),
      PageModel(
        Image.asset('images/1765138886520.jpg', fit: BoxFit.cover),
        title: "Save & Share",
        subtitle: "Save favorites and share with your community.",
        bgColor: Colors.white,
        textColor: Colors.black87,
        icon: Icons.bookmark_added,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ConcentricPageView(
                itemCount: pages.length,
                radius: w * 0.22,
                curve: Curves.fastOutSlowIn,
                duration: const Duration(milliseconds: 850),
                verticalPosition: 0.5,
                colors: pages.map((p) => p.bgColor).toList(),
                itemBuilder: (index) {
                  final page = pages[index % pages.length];
                  final isLastPage = index == pages.length - 1;

                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 200),
                        Container(
                          width: 400,
                          height: 250,
                          child: Opacity(opacity: 0.7, child: page.image),
                        ),
                        SizedBox(height: h * 0.05),

                        // Title
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: w * 0.06,
                            fontWeight: FontWeight.w800,
                            color: page.textColor,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        SizedBox(height: h * 0.02),

                        // Subtitle
                        Text(
                          page.subtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: w * 0.035,
                            color: Colors.black54,
                          ),
                        ),

                        // زر Get Started يظهر فقط في الصفحة الأخيرة
                        if (isLastPage) ...[
                          SizedBox(height: h * 0.05),
                          Container(
                            width: w * 0.5,
                            height: h * 0.055,
                            child: ElevatedButton(
                              onPressed: () {
                               Get.toNamed('/HomeScreen');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: page.textColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 5,
                              ),
                              child: Text(
                                "Get Started",
                                style: TextStyle(
                                  fontSize: w * 0.045,
                                  fontWeight: FontWeight.w700,
                                  color: page.bgColor,
                                ),
                              ),
                            ),
                          ),
                        ],

                        SizedBox(height: h * 0.3), // بديل Spacer
                      ],
                    ),
                  );
                },
                pageController: _controller,
                onChange: (index) {
                  // إزالة الانتقال التلقائي من هنا
                  // سنعتمد فقط على الزر
                },
              ),
            ),

            // زر التخطي في الأعلى
            Positioned(
              top: h * 0.02,
              right: w * 0.05,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.01),
                  ),
                  child: Text(
                    "Skip",
                    style: TextStyle(
                      letterSpacing: 1,
                      fontSize: w * 0.04,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}