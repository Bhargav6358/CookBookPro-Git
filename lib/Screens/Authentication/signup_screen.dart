import 'package:cookbookpro/Screens/Authentication/user_login.dart';
import 'package:cookbookpro/Widgets/CustomTextField.dart';
import 'package:cookbookpro/utils/size_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../Widgets/Text_Button.dart';
import 'signin_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final UserLogin _userLogin = UserLogin();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _confirmpasswordController = TextEditingController();

  String? _emailExistsError;

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      String username = _usernameController.text.trim();

      try {
        // Attempt to sign up with the provided email and password
        final user = await _userLogin.signUpWithEmailAndPassword(
            email, password, username);
        if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SignInScreen()),
          );
          print('User signed up: ${user.uid}');
        } else {
          _showErrorDialog('Failed to sign up with this email and password.');
          setState(() {
            _emailExistsError = 'This email is already registered.';
          });
        }
      } catch (e) {
        // Check if the error indicates that the email already exists
        if (e is FirebaseAuthException && e.code == 'email-already-in-use') {
          setState(() {
            _emailExistsError = 'This email is already registered.';
          });
        } else {
          _showErrorDialog('Failed to sign up: $e');
        }
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  60.ph,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Create an account",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      5.ph,
                      Text(
                        "Let's help you set up your account,\nit won't take long.",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                  30.ph,
                  CustomTextField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your username.';
                      }
                      return null;
                    },
                    hint: "Enter Name",
                    controller: _usernameController,
                    baseColor: Theme.of(context).colorScheme.outline,
                    borderColor: Theme.of(context).colorScheme.primary,
                    errorColor: Theme.of(context).colorScheme.error,
                    TextFelidHeadline: "Name",
                  ),
                  20.ph,
                  CustomTextField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email.';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    },
                    errorText: _emailExistsError,
                    hint: "Enter Email",
                    controller: _emailController,
                    baseColor: Theme.of(context).colorScheme.outline,
                    borderColor: Theme.of(context).colorScheme.primary,
                    errorColor: Theme.of(context).colorScheme.error,
                    TextFelidHeadline: "Email",
                  ),
                  20.ph,
                  CustomTextField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password.';
                      }
                      return null;
                    },
                    hint: "Enter Password",
                    controller: _passwordController,
                    baseColor: Theme.of(context).colorScheme.outline,
                    borderColor: Theme.of(context).colorScheme.primary,
                    errorColor: Theme.of(context).colorScheme.error,
                    TextFelidHeadline: "Password",
                  ),
                  20.ph,
                  CustomTextField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please confirm your password.';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match.';
                      }
                      return null;
                    },
                    hint: "Confirm Password",
                    controller: _confirmpasswordController,
                    baseColor: Theme.of(context).colorScheme.outline,
                    borderColor: Theme.of(context).colorScheme.primary,
                    errorColor: Theme.of(context).colorScheme.error,
                    TextFelidHeadline: "Confirm Password",
                  ),
                  20.ph,
                  CusTextButton1(
                    text: 'Sign Up',
                    onPressed: () {
                      _signUp();
                    },
                    icon: CupertinoIcons.arrow_right_circle,
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignInScreen()),
                          );
                        },
                        child: Text(
                          "SignIn",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
