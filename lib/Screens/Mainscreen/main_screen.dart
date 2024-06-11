import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../Model/RecipeModel.dart';
import '../../Widgets/CustomSerchTextField.dart';
import '../../utils/imageConstant.dart';
import '../RecipeDetailScreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<String> categories = [
    'All', 'Indian', 'Italian', 'Chinese', 'Mexican', 'Asian',
    'American', 'Thai', 'Pakistani', 'Mediterranean', 'Japanese',
    'Moroccan', 'Korean', 'Greek'
  ];
  int selectedIndex = 0;
  Map<String, dynamic>? filters;

  void applyFilters(Map<String, dynamic> newFilters) {
    setState(() {
      filters = newFilters;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const AppBarSection(),
          const SearchArea(),
          Container(
            margin: const EdgeInsets.only(left: 20, top: 20),
            height: 30,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    print('Selected Index: $index');
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: selectedIndex == index ? Theme.of(context).colorScheme.primary : Colors.transparent,
                      border: Border.all(
                        color: selectedIndex == index ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outline,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        categories[index],
                        style: TextStyle(
                          fontSize: 11,
                          color: selectedIndex == index ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: FoodData(
              selectedCategory: categories[selectedIndex],
              filters: filters,
            ),
          ),
        ],
      ),
    );
  }
}



class AppBarSection extends StatefulWidget {
  const AppBarSection({super.key});

  @override
  State<AppBarSection> createState() => _AppBarSectionState();
}

class _AppBarSectionState extends State<AppBarSection> {
  late String userName = '';

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userData = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
        setState(() {
          userName = userData['username'] ?? '';
        });
      }
    } catch (e) {
      // Handle error
    }
  }



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Hello ",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        userName.isEmpty ? "Loading..." : "$userName...",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  Text(
                    "What are you cooking today?",
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xffFFCE80),
                ),
                child: Image.asset(
                  ImageConstant.Mainscreen_profile,
                  width: 40,
                  height: 40,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class FilterBottomSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onApply;

  const FilterBottomSheet({required this.onApply, Key? key}) : super(key: key);

  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  // Difficulty Levels
  List<String> difficulties = ['Easy', 'Medium', 'Hard'];
  List<String> selectedDifficulties = [];

  // Cook and Prep Time
  RangeValues cookTimeRange = RangeValues(0, 120);
  RangeValues prepTimeRange = RangeValues(0, 120);

  // Minimum Review Count
  String? selectedReviewCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Filter Recipes',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),

              // Difficulty Checkboxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: difficulties.map((difficulty) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: selectedDifficulties.contains(difficulty),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              selectedDifficulties.add(difficulty);
                            } else {
                              selectedDifficulties.remove(difficulty);
                            }
                          });
                        },
                      ),
                      Text(difficulty),
                    ],
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Cook Time Range Slider
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 15),
                      child:  Text('Cook Time (minutes)',style: Theme.of(context).textTheme.displayMedium,)),
                  RangeSlider(
                    values: cookTimeRange,
                    min: 0,
                    max: 120,
                    divisions: 24,

                    labels: RangeLabels(
                      '${cookTimeRange.start.round()}',
                      '${cookTimeRange.end.round()}',
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        cookTimeRange = values;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Prep Time Range Slider
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(padding: EdgeInsets.only(left: 15),child: Text('Prep Time (minutes)',style: Theme.of(context).textTheme.displayMedium,)),
                  RangeSlider(
                    values: prepTimeRange,
                    min: 0,
                    max: 120,
                    divisions: 24,
                    labels: RangeLabels(
                      '${prepTimeRange.start.round()}',
                      '${prepTimeRange.end.round()}',
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        prepTimeRange = values;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Minimum Review Count Radio Buttons
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(padding: EdgeInsets.only(left: 15),child: Text('Minimum Review Count',style: Theme.of(context).textTheme.displayMedium,)),
                  RadioListTile<String>(
                    title:  Text('>50 reviews', style: Theme.of(context).textTheme.bodyMedium,),
                    value: '>50',
                    groupValue: selectedReviewCount,
                    onChanged: (String? value) {
                      setState(() {
                        selectedReviewCount = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title:  Text('>100 reviews', style: Theme.of(context).textTheme.bodyMedium,),
                    value: '>100',
                    groupValue: selectedReviewCount,
                    onChanged: (String? value) {
                      setState(() {
                        selectedReviewCount = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title:  Text('>150 reviews', style: Theme.of(context).textTheme.bodyMedium,),
                    value: '>150',
                    groupValue: selectedReviewCount,
                    onChanged: (String? value) {
                      setState(() {
                        selectedReviewCount = value;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Apply and Cancel Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,

                    ),
                    onPressed: () {
                      widget.onApply({
                        'difficulties': selectedDifficulties,
                        'cookTimeRange': cookTimeRange,
                        'prepTimeRange': prepTimeRange,
                        'reviewCount': selectedReviewCount,
                      });
                    },
                    child:  Text('Apply',style: Theme.of(context).textTheme.titleMedium,),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class SearchArea extends StatefulWidget {
  const SearchArea({super.key});

  @override
  State<SearchArea> createState() => _SearchAreaState();
}

class _SearchAreaState extends State<SearchArea> {
  void _openFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FilterBottomSheet(
          onApply: (Map<String, dynamic> filters) {
            Navigator.of(context).pop();
            // Pass the filters to the parent widget
            context.findAncestorStateOfType<_MainScreenState>()?.applyFilters(filters);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomSearchTextField(
            hint: "Search recipe",
            controller: searchController,
            baseColor: Theme.of(context).colorScheme.outline,
            borderColor: Theme.of(context).colorScheme.primary,
            errorColor: Theme.of(context).colorScheme.error,
          ),
          Container(
            height: 40,
            width: 40,
            child: IconButton.filledTonal(
              onPressed: () {
                _openFilterBottomSheet();
              },
              icon: const Icon(CupertinoIcons.slider_horizontal_3, color: Colors.white),
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}




class FoodData extends StatefulWidget {
  final String selectedCategory;
  final Map<String, dynamic>? filters;

  const FoodData({required this.selectedCategory, this.filters, Key? key}) : super(key: key);

  @override
  _FoodDataState createState() => _FoodDataState();
}

class _FoodDataState extends State<FoodData> {
  List<Recipe> dishes = [];
  List<Recipe> filteredDishes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDishes();
  }

  Future<void> _loadDishes() async {
    try {
      final response = await http.get(Uri.parse('https://dummyjson.com/recipes'));
      if (response.statusCode == 200) {
        final recipeModel = recipemodelFromJson(response.body);
        setState(() {
          dishes = recipeModel.recipes;
          _filterDishes();
          isLoading = false;
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterDishes() {
    List<Recipe> filteredList = dishes;

    // Filter by category
    if (widget.selectedCategory != 'All') {
      filteredList = filteredList.where((dish) {
        print('Checking category: ${dish.cuisine}');
        return dish.cuisine.toLowerCase() == widget.selectedCategory.toLowerCase();
      }).toList();
    }

    // Apply additional filters if they exist
    if (widget.filters != null) {
      // Filter by difficulties
      if (widget.filters!['difficulties'] != null && widget.filters!['difficulties'].isNotEmpty) {
        filteredList = filteredList.where((dish) {
          print('Checking difficulty: ${dish.difficulty}');
          return widget.filters!['difficulties'].contains(dish.difficulty);
        }).toList();
      }

      // Filter by cook time range
      if (widget.filters!['cookTimeRange'] != null) {
        filteredList = filteredList.where((dish) {
          print('Checking cook time: ${dish.cookTimeMinutes}');
          return dish.cookTimeMinutes >= widget.filters!['cookTimeRange'].start &&
              dish.cookTimeMinutes <= widget.filters!['cookTimeRange'].end;
        }).toList();
      }

      // Filter by prep time range
      if (widget.filters!['prepTimeRange'] != null) {
        filteredList = filteredList.where((dish) {
          print('Checking prep time: ${dish.prepTimeMinutes}');
          return dish.prepTimeMinutes >= widget.filters!['prepTimeRange'].start &&
              dish.prepTimeMinutes <= widget.filters!['prepTimeRange'].end;
        }).toList();
      }

      // Filter by review count
      if (widget.filters!['reviewCount'] != null) {
        int reviewThreshold = int.parse(widget.filters!['reviewCount']!.substring(1));
        filteredList = filteredList.where((dish) {
          print('Checking review count: ${dish.reviewCount}');
          return dish.reviewCount >= reviewThreshold;
        }).toList();
      }
    }

    setState(() {
      filteredDishes = filteredList;
      print('Filtered list: ${filteredDishes.length} items');
    });
  }


  @override
  void didUpdateWidget(FoodData oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedCategory != widget.selectedCategory || oldWidget.filters != widget.filters) {
      _filterDishes();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (filteredDishes.isEmpty) {
      return const Center(
        child: Text('No recipes found for this category.'),
      );
    } else {
      return Container(
        margin: const EdgeInsets.only(left: 20, top: 20, right: 20),
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: filteredDishes.length,
          itemBuilder: (BuildContext context, int index) {
            final dish = filteredDishes[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailScreen(recipe: dish),
                  ),
                );
              },
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
                          Image.network(
                            dish.image,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
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
                                stops: [0.0, 0.7],
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
                                  dish.name,
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  dish.cuisine,
                                  style: Theme.of(context).textTheme.titleSmall,
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
                            dish.rating.toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    }
  }
}



