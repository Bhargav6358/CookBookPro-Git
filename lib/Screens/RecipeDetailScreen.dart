import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cookbookpro/Widgets/AppBar.dart';

import '../Model/RecipeModel.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    _checkIfRecipeIsSaved();
  }

  Future<void> _checkIfRecipeIsSaved() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final recipeRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('saved_recipes');

      // Use a unique identifier for checking if the recipe is already saved
      final querySnapshot = await recipeRef
          .where('id', isEqualTo: widget.recipe.id)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          isSaved = true;
        });
      }
    }
  }

  Future<void> saveRecipe(Map<String, dynamic> recipe) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final recipeRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('saved_recipes');
      await recipeRef.add(recipe);
    }
  }

  Future<void> unsaveRecipe(Map<String, dynamic> recipe) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final recipeRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('saved_recipes');

      // Query for the document corresponding to the recipe's unique identifier
      final querySnapshot = await recipeRef
          .where('id', isEqualTo: recipe['id'])
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final documentId = querySnapshot.docs.first.id;
        await recipeRef.doc(documentId).delete();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomAppBar(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
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
                                height: 200,
                                width: double.infinity,
                                child: widget.recipe.image.startsWith('http')
                                    ? Image.network(
                                  widget.recipe.image,
                                  fit: BoxFit.cover,
                                )
                                    : Image.asset(
                                  widget.recipe.image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.8),
                                      Colors.black.withOpacity(0.2),
                                    ],
                                    stops: const [0.0, 0.7],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                left: 10,
                                right: 10,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.recipe.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'By ${widget.recipe.difficulty}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
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
                                widget.recipe.rating.toString(),
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
                            if (isSaved) {
                              unsaveRecipe(widget.recipe.toJson());
                              setState(() {
                                isSaved = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Recipe unsaved!'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            } else {
                              saveRecipe(widget.recipe .toJson());
                              setState(() {
                                isSaved = true;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Recipe saved!'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          backgroundColor: Colors.white,
                          child: Icon(
                            isSaved ? Icons.bookmark : Icons.bookmark_border,
                            color: isSaved ? Colors.teal : Colors.grey,
                            size: 20,
                          ),
                          mini: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.recipe.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Ingredients:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 8),
                  for (String ingredient in widget.recipe.ingredients)
                    Text(
                      '- $ingredient',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  const SizedBox(height: 16),
                  const Text(
                    'Recipe:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.recipe.instructions.toString(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
