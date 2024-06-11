import 'package:flutter/material.dart';

import '../HomeScreen.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications",style: Theme.of(context).textTheme.bodyMedium,),
        leading: Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 0,left: 10),
          height: kToolbarHeight, // Set height for the app bar
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> Homescreen()));
            },
          ), // Wrap CustomAppBar in a container with specified height
        ),
      ),
      body: Column(
        children: [
          Center(

            child: Container(
              padding: EdgeInsets.symmetric(vertical: 300),
              child: Text("No notification available."),
            ),
          ),
        ],
      ),
    );
  }
}
