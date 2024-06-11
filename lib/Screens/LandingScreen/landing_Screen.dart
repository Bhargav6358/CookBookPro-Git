import 'package:cookbookpro/Screens/Authentication/signup_screen.dart';
import 'package:cookbookpro/utils/imageConstant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../Widgets/Text_Button.dart';


class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
 }

class _LandingScreenState extends State<LandingScreen> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Background image
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImageConstant
                      .SplashScreenImg), // Ensure you have this image in your assets folder
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0),
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(1)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            // Content
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(30),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 100), // Spacing for top status bar area
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage(ImageConstant.SplashScreenLogo),
                            fit: BoxFit.cover,
                          )),
                        ),
                        SizedBox(height: 20),
                        Text(
                          '100K+ Premium Recipe',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 4.5,
                        ),
                        Column(
                          children: [
                            Text(
                              'Get\nCooking',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 45,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 15),
                            Text(
                              'Simple way to find Tasty Recipe',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 50), // Spacing for bottom button
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              left: 30,
              right: 30,
              child: CusTextButton1(
                text: 'Start Cooking',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SignUpScreen()));
                },
                icon: CupertinoIcons.arrow_right_circle,

              ),
            ),
          ],
        ),
      ),
    );
  }
}
