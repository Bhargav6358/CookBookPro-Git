import 'dart:io';

import 'package:cookbookpro/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../HomeScreen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  late String _userName = ''; // Initialize _userName with an empty string
  late String _userEmail = ''; // Initialize _userEmail with an empty string
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    if (_user != null) {
      _firestore.collection('users').doc(_user!.uid).get().then((document) {
        if (document.exists) {
          setState(() {
            _userName = document['username'];
            _userEmail = _user!.email!;
          });
        }
      });
    }
  }

  Future<void> _logout() async {
    try {
      await _auth.signOut();
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (error) {
      print("Error logging out: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile",style: Theme.of(context).textTheme.bodyMedium,),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!)
                      : AssetImage('assets/img/profile.png') as ImageProvider,
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.only(left: 20,top: 12),
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.teal),
                ),
                child: Text(_userName),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.only(left: 20,top: 12),
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.teal),
                ),
                child: Text(_userEmail),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 90),
                child: ElevatedButton(
                  onPressed: _logout,
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colors.black,
                        size: 20,
                      ),
                      15.pw,
                      Text(
                        'Logout',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
