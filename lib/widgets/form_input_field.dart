import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../style.dart';

class Forminputfield extends StatelessWidget {
 final String? Function(String?)? valdator;
  final String hint;
  final controller;
  const Forminputfield ({super.key, required this.hint, this.controller, this.valdator,});

  @override
  Widget build(BuildContext context) {
    return Container(

     margin: inputFieldPadding,

     child: TextFormField(
       cursorColor: Colors.blue,
        validator: valdator,
       controller: controller,

       decoration: InputDecoration(

         fillColor: Color.fromARGB(255, 255, 255, 255),
         filled: true,

         border: OutlineInputBorder(
           borderSide:BorderSide.none,
           borderRadius: BorderRadius.all(Radius.circular(10)),


         ),



         hint:Text(hint,style: TextStyle(color: hintTextColor),),
         // prefixIcon: Icon(Icons.email_outlined,color: ,),
       ),
     ),
    );
  }
}
