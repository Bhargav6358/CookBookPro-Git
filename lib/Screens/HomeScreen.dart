import 'package:flutter/material.dart';

import 'Mainscreen/main_screen.dart';
import 'Notifications/notification_screen.dart';
import 'Profile/profile_screen.dart';
import 'SavedItem/saved_recipe.dart';

class Homescreen extends StatefulWidget {
  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    MainScreen(),
    SavedRecipeScreen(),
    NotificationScreen(),
    ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text('Do you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _screens[_currentIndex],

        bottomNavigationBar: BottomAppBar(
          padding: EdgeInsets.symmetric(horizontal: 30),
          shadowColor: Colors.grey,
          elevation: 10,
          surfaceTintColor: Colors.white,
          shape: const CircularNotchedRectangle(),
          notchMargin: 7.0,
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                highlightColor: Colors.transparent,
                icon: Icon(Icons.home_rounded,
                    color: _currentIndex == 0 ? Colors.teal : Colors.grey),
                onPressed: () => _onTabTapped(0),
              ),
              IconButton(
                highlightColor: Colors.transparent,
                icon: Icon(Icons.bookmark,
                    color: _currentIndex == 1 ? Colors.teal : Colors.grey),
                onPressed: () => _onTabTapped(1),
              ),
              IconButton(
                highlightColor: Colors.transparent,
                icon: Icon(Icons.notifications,
                    color: _currentIndex == 2 ? Colors.teal : Colors.grey),
                onPressed: () => _onTabTapped(2),
              ),
              IconButton(
                highlightColor: Colors.transparent,
                icon: Icon(Icons.person,
                    color: _currentIndex == 3 ? Colors.teal : Colors.grey),
                onPressed: () => _onTabTapped(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
