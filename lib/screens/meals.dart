import 'package:flutter/material.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/widgets/meal_item.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({super.key, required this.title, required this.meals,required this.onToggleFavourite});

  final String title;
  final List<Meal> meals;
  final void Function(Meal meal) onToggleFavourite;
 
  @override
  Widget build(BuildContext context) {
    Widget content =
        ListView.builder(itemCount: meals.length,itemBuilder: (ctx, index) => MealItem(meal: meals[index],onToggleFavourite: onToggleFavourite,));
    if (meals.isEmpty) {
      content = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("uh oh ...no items here!",
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground)),
            const SizedBox(
              height: 16,
            ),
            Text(
              "try Selecting a different Category",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            )
          ],
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: content,
    );
  }
}