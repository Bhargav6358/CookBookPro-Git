import 'package:cookbookpro/Screens/LandingScreen/landing_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Screens/Authentication/signin_screen.dart';
import 'Screens/HomeScreen.dart';
import 'Screens/Profile/profile_screen.dart';

class MyAppView extends StatelessWidget {
  const   MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Expense Tracker",
      theme: ThemeData(
        textTheme: TextTheme(
          displaySmall : GoogleFonts.montserrat(
              fontSize: 12,fontWeight: FontWeight.w500, color: Colors.grey),

          displayMedium : GoogleFonts.montserrat(
              fontSize: 16,fontWeight: FontWeight.w500, color: Colors.grey),

          displayLarge : GoogleFonts.montserrat(
              fontSize: 20,fontWeight: FontWeight.w500, color: Colors.grey),

          bodySmall:GoogleFonts.montserrat(
              fontSize: 12,fontWeight: FontWeight.w600, color: Colors.black),

          bodyMedium: GoogleFonts.montserrat(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w700),

          bodyLarge:  GoogleFonts.montserrat(
              fontSize: 20,  fontWeight: FontWeight.w700, color: Colors.black),

          titleMedium: GoogleFonts.montserrat(
              fontSize: 16,  fontWeight: FontWeight.w600, color: Colors.white),
          titleSmall: GoogleFonts.montserrat(
              fontSize: 14,  fontWeight: FontWeight.w600, color: Colors.teal.shade300),
          labelLarge: GoogleFonts.montserrat(
              fontSize: 14,  fontWeight: FontWeight.w600, color: Colors.black),
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        fontFamily: "Poppins",
        colorScheme: ColorScheme.light(
          background: Colors.grey.shade100,
          onBackground: Colors.black,
          primary: Colors.teal,
          secondary: const Color(0xffff9c00),
          outline: const Color(0xff4a5c6a),
          error: const Color(0xffFD3654),

        ),
      ),

      routes: {

        '/login': (context) => SignInScreen(), // Your login screen
        '/profile': (context) => ProfileScreen(),
      },
      home: AuthWrapper(),
    );
  }
}
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading indicator while checking authentication state
        } else {
          if (snapshot.hasData && snapshot.data != null) {
            return Homescreen(); // User is signed in, navigate to main screen
          } else {
            return LandingScreen(); // User is not signed in, show sign-in screen
          }
        }
      },
    );
  }
}

