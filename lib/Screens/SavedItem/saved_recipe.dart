import 'package:cookbookpro/Screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../Widgets/AppBar.dart';

class SavedRecipeScreen extends StatefulWidget {
  @override
  _SavedRecipeScreenState createState() => _SavedRecipeScreenState();
}

class _SavedRecipeScreenState extends State<SavedRecipeScreen> {
  late Stream<QuerySnapshot> _savedRecipesStream;

  @override
  void initState() {
    super.initState();
    _savedRecipesStream = _getSavedRecipesStream();
  }

  Stream<QuerySnapshot> _getSavedRecipesStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('saved_recipes')
          .snapshots();
    } else {
      return Stream<QuerySnapshot>.empty();
    }
  }

  Future<void> unsaveRecipe(Map<String, dynamic> recipe) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final recipeRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('saved_recipes');

      // Query for the document corresponding to the recipe
      final querySnapshot =
          await recipeRef.where('name', isEqualTo: recipe['name']).get();

      // If the document exists, delete it
      if (querySnapshot.docs.isNotEmpty) {
        final documentId = querySnapshot.docs.first.id;
        await recipeRef.doc(documentId).delete();
      }
    }
  }

  void _confirmUnsaveRecipe(BuildContext context, Map<String, dynamic> recipe) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Unsave Recipe'),
          content: Text('Are you sure you want to unsave this recipe?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await unsaveRecipe(recipe);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Favorite Recipe",style: Theme.of(context).textTheme.bodyMedium,),
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: StreamBuilder<QuerySnapshot>(
                stream: _savedRecipesStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text('No saved recipes.'),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    return ListView(
                      children: snapshot.data!.docs.map((doc) {
                        final recipe = {
                          'name': doc['name'],
                          'cuisine': doc['cuisine'],
                          'image': doc['image'],
                          'rating': doc['rating'],
                        };
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                        height: 200, // Set a specific height
                                        width: double.infinity,
                                        child:
                                        Image.network(
                                          doc['image'],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Container(
                                        height: 200, // Set a specific height
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            colors: [
                                              Colors.black.withOpacity(0.8),
                                              Colors.black.withOpacity(0.2),
                                            ],
                                            stops: [0.0, 0.7],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 10,
                                        left: 10,
                                        right: 10,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              doc['name'],
                                              style: Theme.of(context).textTheme.titleMedium
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              doc['cuisine'],
                                              style: Theme.of(context).textTheme.titleSmall
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        size: 12,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        doc['rating'].toString(),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 8,
                                right: 8,
                                child: FloatingActionButton(
                                  onPressed: () {
                                    _confirmUnsaveRecipe(context, recipe);
                                  },
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.bookmark_remove,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                  mini: true,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
