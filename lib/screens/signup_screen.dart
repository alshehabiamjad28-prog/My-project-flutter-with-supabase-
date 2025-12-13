import 'package:fire/widgets/elevated_button.dart';
import 'package:fire/widgets/form_input_field.dart';
import 'package:flutter/material.dart';
import '../services/auth_servire.dart';
import '../style.dart';
import '../utils/validators.dart';
import 'signin_screen.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<SignupPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();
  GlobalKey<FormState> form = GlobalKey();

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
                    style: TextStyle(fontSize: 22, color: secondaryTextColor,letterSpacing: 1.1,fontWeight: FontWeight.w600),

                  ),
                ),

                SizedBox(height: marginLarge * 1.9),

                Container(
                  child: Text(
                    "Sign up",
                    style: TextStyle(
                        fontSize: 26,
                        color: Color(0xFF111827),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                        shadows: [

                        ]
                    ),


                  ),
                ),

                SizedBox(height: marginLarge),

                Forminputfield(
                  hint: "user name",
                  controller: username,
                  valdator: Validusername,
                ),

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
                  title: "Sign Up",
                  onPressed: () async {
                    if (form.currentState!.validate()) {
                      try {
                        await AuthService().signUp(
                          email.text,
                          password.text,
                          username.text,
                        );

                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(

                            backgroundColor:  Color.fromARGB(255, 125, 246, 133),
                            content: Text("Account created successfully")));
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(
                            backgroundColor:  Color.fromARGB(255, 255, 90, 65),

                            content: Text(e.toString())));
                      }
                    } else {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(
                          backgroundColor:  Color.fromARGB(255, 255, 90, 65),
                          content: Text("An error occurred while creating account")));
                    }
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
                        "Sign up with google",
                        style: TextStyle(color: secondaryTextColor),
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
                          "Already  have an acount? ",
                          style: TextStyle(color: secondaryTextColor),
                        ),

                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            );
                          },
                          child: Text(
                            "Log In",
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
