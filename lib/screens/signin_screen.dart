import 'package:fire/widgets/elevated_button.dart';
import 'package:fire/widgets/form_input_field.dart';
import 'package:flutter/material.dart';

import '../services/auth_servire.dart';
import '../style.dart';
import '../utils/validators.dart';
import 'listpages_screen.dart';
import 'signup_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  GlobalKey<FormState> form = GlobalKey();

  validators() async {
    if (form.currentState!.validate()) {
      try {
        final user = await AuthService().signIn(
          email.text.trim(),
          password.text.trim(),
        );

        if (user != null) {
          // ✅ Login successful
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Color.fromARGB(255, 125, 246, 133),
              content: Text("Login successful"),
            ),
          );

          // Navigate to home page
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => PageList()),
          );
        } else {
          // ❌ User not found or incorrect password
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Color.fromARGB(255, 255, 90, 65),

              content: Text("User not found or incorrect password"),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Color.fromARGB(255, 255, 90, 65),

            content: Text("An error occurred during login: $e"),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color.fromARGB(255, 255, 90, 65),

          content: Text("Please check the entered data"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.only(
            top: paddingLarge * 2,
            left: paddingLarge,
            right: paddingLarge * 2,
          ),
          child: Form(
            key: form,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,

                  child: Icon(
                    Icons.my_library_books_outlined,
                    size: iconSizeLarge * 2,
                    color: primaryButtonColor,
                  ),
                ),

                SizedBox(height: marginLarge - 7),

                Container(
                  child: Text(
                    "Welcom",
                    style: TextStyle(
                      fontSize: 22,
                      color: secondaryTextColor,
                      letterSpacing: 1.1,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                SizedBox(height: marginLarge * 1.9),

                Container(
                  child: Text(
                    "Sign in",
                    style: TextStyle(
                      fontSize: 26,
                      color: Color(0xFF111827),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                      shadows: [

                      ],
                    ),
                  ),
                ),

                SizedBox(height: marginLarge),

                Forminputfield(
                  hint: "email",
                  controller: email,
                  valdator: validateEmail,
                ),
                Forminputfield(
                  hint: "password",
                  controller: password,
                  valdator: validatePassword,
                ),

                SizedBox(height: 15),

                Elevatedbutton(
                  title: "Sign in",
                  onPressed: () async {
                    validators();
                  },
                ),

                SizedBox(height: 19),

                Text("or", style: TextStyle(color: secondaryTextColor)),

                SizedBox(height: 19),

                ElevatedButton(
                  style: secondaryButtonStyle,

                  onPressed: () {},
                  child: Container(
                    width: 260,
                    height: 23,
                    child: Center(
                      child: Text(
                        "Sign in with google",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 22),

                Container(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don not have an acount? ",
                          style: TextStyle(color: Color(0xFF6B7280)),
                        ),

                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SignupPage(),
                              ),
                            );
                          },
                          child: Text(
                            "Sign up",
                            style: TextStyle(color: primaryButtonColor),
                          ),
                        ),
                      ],
                    ),
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
