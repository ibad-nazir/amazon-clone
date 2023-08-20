import 'package:ecomerceapp/Common/widgets/custom_TextField.dart';
import 'package:ecomerceapp/Common/widgets/custom_buttom.dart';
import 'package:ecomerceapp/constants/global_variable.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';

enum Auth {
  signIn,
  signUp,
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String routeName = "route\\LoginScreen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Auth _auth = Auth.signUp;
  final _signUpFormKey = GlobalKey<FormState>();
  final _signInFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final AuthService authService = AuthService();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void signUpUser() {
    if (_signUpFormKey.currentState!.validate()) {
      authService.signUpUser(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        context: context,
      );
    }
  }

  @override
  Widget build(BuildContext context2) {
    void signInUser() {
      if (_signInFormKey.currentState!.validate()) {
        authService.signInUser(
            context: context2,
            email: _emailController.text,
            password: _passwordController.text);
      }
    }

    return Scaffold(
        backgroundColor: GlobalVariables.greyBackgroundCOlor,
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  "Welcome",
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 15,
                ),
                ListTile(
                  tileColor: _auth != Auth.signUp
                      ? GlobalVariables.greyBackgroundCOlor
                      : GlobalVariables.backgroundColor,
                  title: const Text(
                    'Create Account',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  leading: Radio(
                    value: Auth.signUp,
                    groupValue: _auth,
                    onChanged: (Auth? auth) {
                      setState(() {
                        _auth = auth!;
                      });
                    },
                    activeColor: GlobalVariables.secondaryColor,
                  ),
                ),
                if (_auth == Auth.signUp)
                  Container(
                    color: GlobalVariables.backgroundColor,
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _signUpFormKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: _nameController,
                            hintText: 'Name',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextField(
                            controller: _emailController,
                            hintText: 'Email',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextField(
                            controller: _passwordController,
                            hintText: 'Password',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomButton(onTap: signUpUser, text: 'Sign-Up')
                        ],
                      ),
                    ),
                  ),
                ListTile(
                  tileColor: _auth == Auth.signUp
                      ? GlobalVariables.greyBackgroundCOlor
                      : GlobalVariables.backgroundColor,
                  title: const Text(
                    'Sign In',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  leading: Radio(
                    value: Auth.signIn,
                    groupValue: _auth,
                    onChanged: (Auth? auth) {
                      setState(() {
                        _auth = auth!;
                      });
                    },
                    activeColor: GlobalVariables.secondaryColor,
                  ),
                ),
                if (_auth == Auth.signIn)
                  Container(
                    color: GlobalVariables.backgroundColor,
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _signInFormKey,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextField(
                            controller: _emailController,
                            hintText: 'Email',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextField(
                            controller: _passwordController,
                            hintText: 'Password',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomButton(onTap: signInUser, text: 'Sign-In'),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ));
  }
}
