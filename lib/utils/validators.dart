
String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'يرجى إدخال البريد الإلكتروني';
  }
  final emailRegex = RegExp(r'^[\w-.]+@([\w-]+.)+[\w-]{2,4}$');
  if (!emailRegex.hasMatch(value)) {
    return 'صيغة البريد الإلكتروني غير صحيحة';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'يرجى إدخال كلمة المرور';
  }
  if (value.length < 6) {
    return 'كلمة المرور يجب أن تكون على الأقل 6 أحرف';
  }
  return null;
}

String?  Validusername(String? value){
  if(value == null || value.isEmpty){

    return 'يرجى إدخال الاسم';


  }

}


String? validateTitle(String? value) {
  if (value == null || value.isEmpty) {
    return 'لا يمكن ترك العنوان فارغ';
  }
  if (value.trim() == 'null') {
    return 'لا يمكن ترك العنوان فارغ';
  }
  return null;
}

String? validateContent(String? value) {
  if (value == null || value.isEmpty) {
    return 'لا يمكن ترك الحقل فارغ';
  }
  if (value.trim() == 'null') {
    return 'لا يمكن ترك الحقل فارغ';
  }
  if (value.length < 100) { // يمكنك تغيير الرقم حسب احتياجك
    return 'النص قصير جداً';
  }
  return null;
}







