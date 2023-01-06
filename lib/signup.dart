import 'package:chat/utils.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class SignUp extends StatefulWidget {

  final VoidCallback onClickedSignIn;

  const SignUp({
    Key? key,
    required this.onClickedSignIn,
  }) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String fullName = "";

  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding : EdgeInsets.symmetric(vertical: 40, horizontal: 16),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Text("CHAT",
                //     style: TextStyle(
                //         fontSize: 40,
                //         fontWeight: FontWeight.bold,
                //         color: Colors.blue[600]
                //     )),
                // Text("Create your account now to chat and explore"),
                SizedBox(height: 55),
                Image.asset("assets/logo.png"),
                SizedBox(height: 55),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText : "Full Name",
                    prefixIcon: Icon(Icons.person)
                  ),
                  onChanged: (val) {
                    setState(() {
                      fullName = val;
                    });
                  },
                  validator: (val) {
                    if(val!.isNotEmpty) {
                      return null;
                    } else {
                      return "Name cannot be empty";
                    }
                  }
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: emailController,
                  cursorColor: Colors.black,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email)),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) =>
                  email != null && !EmailValidator.validate(email)
                      ? 'Enter a valid email'
                      : null,
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: passwordController,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock)),
                  obscureText: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value != null && value.length < 6
                      ? 'Enter minimum 6 characters'
                      : null,
                ),
                SizedBox(height: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                  ),
                  onPressed: Sign,
                  child: Text(
                    'SignUp',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 24),
                RichText(text: TextSpan(
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,),
                  text: 'Already have an account?..',
                  children: [
                    TextSpan(
                      text: 'Log In',
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onClickedSignIn,
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                )),
              ],
            ),
          ),
        )
    );
  }

  Future Sign() async {
    final isValid = formKey.currentState!.validate();
    if(!isValid) return;


    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch(e) {
      print(e);

      Utils.showSnackBar(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
