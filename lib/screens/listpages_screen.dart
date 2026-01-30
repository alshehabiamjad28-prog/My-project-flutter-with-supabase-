import 'package:fire/style.dart';
import 'package:flutter/material.dart';
import 'add_article_screen.dart';
import 'favorites_screen.dart';
import 'home_screen.dart';

class PageList extends StatefulWidget {
  const PageList({super.key});

  @override
  State<PageList> createState() => _PageListState();
}

class _PageListState extends State<PageList> {
  int currentIndexs = 0;
  GlobalKey<ScaffoldState> skf = GlobalKey();

  // دالة التبديل بين الصفحات
  void changePage(int index) {
    if (mounted) {
      setState(() {
        currentIndexs = index;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      key: skf,
      bottomNavigationBar: BottomNavigationBar(
        unselectedIconTheme: IconThemeData(size: 32),
        selectedIconTheme: IconThemeData(size: 35, color: Colors.blue),
        backgroundColor: backgroundColor,
        currentIndex: currentIndexs,
        onTap: (value) {
          setState(() {
            currentIndexs = value;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: "Add",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: "Favorite",
          ),
        ],
      ),
      body: IndexedStack(
        index: currentIndexs,
        children: [
          // 🔥 مرر دالة changePage لـ Homescreen
          Homescreen(onChangePage: changePage),
          Addarticlescreen(),
          FavoritesPage(),
        ],
      ),
    );
  }
}