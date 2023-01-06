import 'package:chat/utils.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'forgot_password.dart';
import 'main.dart';

class SignIn extends StatefulWidget {

  final VoidCallback onClickedSignUp;

  const SignIn({
    Key? key,
    required this.onClickedSignUp,
  }) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
       padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
       child: Form(
       key : formKey,
       child : Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           // SizedBox(height: 35),
           // Text("CHAT",
           //     style: TextStyle(
           //         fontSize: 40,
           //         fontWeight: FontWeight.bold,
           //         color: Colors.blue[600]
           //     )),
           // Text("Create your account now to chat and explore"),
           const SizedBox(height: 55),
           Image.asset("assets/logo.png"),
           const SizedBox(height: 30),

           TextFormField(
             controller: emailController,
             cursorColor: Colors.black,
             textInputAction: TextInputAction.next,
             decoration: const InputDecoration(
                 labelText: 'Email',
                 prefixIcon: Icon(Icons.email)),
             autovalidateMode: AutovalidateMode.onUserInteraction,
             validator: (email) =>
             email != null && !EmailValidator.validate(email)
                 ? 'Enter a valid email'
                 : null,
           ),
           const SizedBox(height: 15),
           TextFormField(
             controller: passwordController,
             textInputAction: TextInputAction.done,
             decoration: const InputDecoration(
                 labelText: 'Password',
                 prefixIcon: Icon(Icons.lock)),
             obscureText: true,
             autovalidateMode: AutovalidateMode.onUserInteraction,
             validator: (value) => value != null && value.length < 6
                 ? 'Enter minimum 6 characters'
                 : null,
           ),
           const SizedBox(height: 15),
           ElevatedButton(
             style: ElevatedButton.styleFrom(
               minimumSize: Size.fromHeight(50),
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(10.0)
               ),
             ),
               onPressed: logIn,
               child: Text(
                 'Sign In',
                 style: TextStyle(fontSize: 18),
               ),
           ),
           SizedBox(height: 24),
           GestureDetector(
             child: Text(
               'Forgot Password?',
               style: TextStyle(
                 decoration: TextDecoration.underline,
                 color: Theme.of(context).colorScheme.secondary,
                 fontSize: 20,
               ),
             ),
             onTap: () => Navigator.of(context).push(MaterialPageRoute(
                 builder: (context) => ForgotPassword(),
             )
             ),
           ),
           const SizedBox(height: 24),
           RichText(
               text: TextSpan(
                 style: const TextStyle(
                     color: Colors.black,
                     fontSize: 18.0),
                 text: "Don't have an account?..",
                 children: [
                   TextSpan(
                     recognizer: TapGestureRecognizer()
                       ..onTap = widget.onClickedSignUp,
                     text: 'Sign Up',
                     style: TextStyle(
                       decoration: TextDecoration.underline,
                        color: Theme.of(context).colorScheme.secondary,
                     ),
                   ),
                 ],
               ),
           ),
         ],
       ),
       ),
      )
    );
  }

  Future logIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()),
    );



    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
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
