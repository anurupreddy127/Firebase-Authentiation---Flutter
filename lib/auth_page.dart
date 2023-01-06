import 'package:chat/signin.dart';
import 'package:chat/signup.dart';
import 'package:flutter/cupertino.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;


  @override
  Widget build(BuildContext context) {
    return isLogin
        ? SignIn(onClickedSignUp: toggle)
        : SignUp(onClickedSignIn : toggle);

  }
  void toggle() => setState(() => isLogin = !isLogin);
}
