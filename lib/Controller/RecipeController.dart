import "package:http/http.dart" as http;

import "../Model/RecipeModel.dart";

recipeItems() async {
  Uri uri = Uri.parse("https://dummyjson.com/recipes");
  var res = await http.get(uri);

  try {
    if (res.statusCode == 200) {
      var data = recipemodelFromJson(res.body);
      return data.recipes;
    } else {
      print("error");
    }
  } catch (e) {
    print(e.toString());
  }
}
