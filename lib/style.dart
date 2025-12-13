// 1. ألوان (Colors)
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final Color backgroundColor =  Color.fromARGB(255, 248, 249, 255);

final Color backgroundButtonNavigationBar = Color.fromARGB(255, 255, 255, 255);
// لون الخلفية الأساسي (أبيض)
final Color cardBackgroundColor = Color(
  0xFFF5F5F5,
); // لون خلفية الكارد (رمادي فاتح)
final Color primaryButtonColor = Color(0xFF007BFF); // زر رئيسي (أزرق)
final Color secondaryButtonColor = Color(0xFF34B7F1); // زر ثانوي (أزرق فاتح)
final Color primaryTextColor = Color(
  0xFF333333,
); // لون النص الأساسي (أسود داكن)
final Color secondaryTextColor = Color(
  0xFF666666,
); // لون النص الثانوي (رمادي غامق)
final Color hintTextColor = Color(
  0xFFAAAAAA,
); // لون النص في الحقول (رمادي فاتح)

// 2. Padding (التباعد)
final double paddingSmall = 8.0; // تباعد صغير
final double paddingMedium = 16.0; // تباعد متوسط
final double paddingLarge = 24.0; // تباعد كبير
final EdgeInsetsGeometry buttonPadding = EdgeInsets.symmetric(
  vertical: 14.0,
  horizontal: 20.0,
); // تباعد الأزرار
final EdgeInsetsGeometry inputFieldPadding = EdgeInsets.symmetric(
  vertical: 12.0,
  horizontal: 20.0,
); // تباعد الحقول

// 3. Margins (الهوامش)
final double marginSmall = 8.0; // هامش صغير
final double marginMedium = 16.0; // هامش متوسط
final double marginLarge = 24.0; // هامش كبير

// 4. Text Styles (أنماط النصوص)
final TextStyle titleTextStyle = TextStyle(
  fontSize: 24.0, // حجم النص
  fontWeight: FontWeight.bold, // سمك الخط
  color: primaryTextColor, // لون النص
);

final TextStyle bodyTextStyle = TextStyle(
  fontSize: 16.0, // حجم النص العادي
  fontWeight: FontWeight.normal,
  color: primaryTextColor, // لون النص
);

final TextStyle hintTextStyle = TextStyle(
  fontSize: 16.0,
  color: hintTextColor, // لون النص في الحقول
);

// 5. Button Styles (أنماط الأزرار)
final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: primaryButtonColor, // لون الزر الأزرق
  padding: buttonPadding, // تباعد الأزرار
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8.0), // حواف دائرية
  ),
);

final ButtonStyle secondaryButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Color(0xFFFFFFFF), // رمادي فاتح جداً
  padding: buttonPadding, // تباعد الأزرار
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8.0), // حواف دائرية
  ),
);

// 6. Input Field Sizes (أحجام الحقول)
final double inputFieldHeight = 50.0; // ارتفاع الحقل
final double inputFieldBorderRadius = 8.0; // نصف قطر الحدود
final double inputFieldFontSize = 16.0; // حجم خط الحقل

// 7. Icon Sizes (أحجام الأيقونات)
final double iconSizeSmall = 24.0; // حجم الأيقونة الصغيرة
final double iconSizeMedium = 32.0; // حجم الأيقونة المتوسطة
final double iconSizeLarge = 40.0; // حجم الأيقونة الكبيرة

// 8. Card Styles (أنماط البطاقات)
final double cardElevation = 4.0; // تأثير الظل
final double cardBorderRadius = 12.0; // نصف قطر الحدود للكارد

// 9. Container Sizes (أحجام الحاويات)
final double containerHeightSmall = 60.0; // ارتفاع الحاوية الصغيرة
final double containerHeightMedium = 100.0; // ارتفاع الحاوية المتوسطة
final double containerHeightLarge = 150.0; // ارتفاع الحاوية الكبيرة
