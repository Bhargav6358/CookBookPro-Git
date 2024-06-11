import 'package:cookbookpro/utils/size_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../Widgets/CustomTextField.dart';
import '../../Widgets/Text_Button.dart';
import '../HomeScreen.dart';
import 'signup_screen.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _signInError;

  void _signIn() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // If sign-in is successful, navigate to the home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Homescreen()),
        );
      } catch (e) {
        // If sign-in fails, display an error message
        print('Failed to sign in: $e');
        setState(() {
          _signInError = 'Invalid email or password. Please try again.';
        });
      }
    }
  }

  void _resetPassword() async {
    String email = _emailController.text.trim();

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // Show a confirmation dialog or snackbar to inform the user that a password reset email has been sent
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Password Reset Email Sent'),
            content: Text(
                'A password reset email has been sent to $email. Please check your inbox.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Handle errors, such as invalid email or user not found
      print('Failed to send password reset email: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Failed to Send Password Reset Email'),
            content: Text(
                'An error occurred while sending the password reset email. Please try again.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        extendBody: false,
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
                        "Hello,",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Welcome Back!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                  60.ph,
                  CustomTextField(
                    hint: 'Enter your email',
                    controller: _emailController,
                    inputType: TextInputType.emailAddress,
                    baseColor: Theme.of(context).colorScheme.outline,
                    borderColor: Theme.of(context).colorScheme.primary,
                    errorColor: Colors.red,
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
                    TextFelidHeadline: 'Email',
                  ),
                  20.ph,
                  CustomTextField(
                      hint: "Enter your password",
                      obscureText: true,
                      controller: _passwordController,
                      baseColor: Theme.of(context).colorScheme.outline,
                      borderColor: Theme.of(context).colorScheme.primary,
                      errorColor: Theme.of(context).colorScheme.error,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your password.';
                        }
                        return null;
                      },
                      TextFelidHeadline: "Password"),
                  10.ph,

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _resetPassword,
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                      ),
                    ],
                  ),

                  if (_signInError != null)
                    Text(
                      _signInError!,
                      style: TextStyle(color: Colors.red),
                    ),
                  20.ph,
                  CusTextButton1(
                    text: 'Sign In',
                    onPressed: () {
                      _signIn();

                    },
                    icon: CupertinoIcons.arrow_right_circle,

                  ),
                  20.ph,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpScreen()),
                          );
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary
                          ),
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
