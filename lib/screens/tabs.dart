import 'package:flutter/material.dart';
import 'package:meals/data/dummy_data.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/filters.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/main_drawer.dart';
import 'package:meals/screens/filters.dart';

const kInitialFilters = {filter.glutenfree: false, filter.lactoseFree: false};

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  Map<filter, bool> _selectedFilters = kInitialFilters;
  int _selectedpageindex = 0;
  final List<Meal> _favouriteMeals = [];
  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _toggleMealFavoriteStatus(Meal meal) {
    final isExisting = _favouriteMeals.contains(meal);
    if (isExisting) {
      setState(() {
        _favouriteMeals.remove(meal);
      });
      _showInfoMessage("Meal is no longer a favourite");
    } else {
      setState(() {
        _favouriteMeals.add(meal);
      });
    }
  }

  void _selectPage(int index) {
    setState(() {
      _selectedpageindex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == "filters") {
      final result =
          await Navigator.of(context).push<Map<filter, bool>>(MaterialPageRoute(
              builder: (ctx) => FilterScreen(
                    currentFilters: _selectedFilters,
                  )));
      // ignore: avoid_print
      print(result);

      setState(() {
        _selectedFilters = result ?? kInitialFilters;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final availablemeals = dummyMeals.where((element) {
      if (_selectedFilters[filter.glutenfree]! && !element.isGlutenFree) {
        return false;
      }
      if (_selectedFilters[filter.lactoseFree]! && !element.isLactoseFree) {
        return false;
      }
      return true;
    }).toList();
    Widget activePage = CategoriesScreen(
      onToggleFavourite: _toggleMealFavoriteStatus,
      availableMeals: availablemeals,
    );
    var activePageTitle = "Categories";

    if (_selectedpageindex == 1) {
      setState(() {
        activePage = MealsScreen(
            title: "Favourites",
            meals: _favouriteMeals,
            onToggleFavourite: _toggleMealFavoriteStatus);
        activePageTitle = "Your Favourites";
      });
    }

    return Scaffold(
      appBar: AppBar(),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedpageindex,
          onTap: _selectPage,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.food_bank), label: "Categories"),
            BottomNavigationBarItem(icon: Icon(Icons.star), label: "Favourites")
          ]),
    );
  }
}
