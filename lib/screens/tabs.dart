import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/provider/filter_provider.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/filters.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/main_drawer.dart';
import 'package:meals/provider/favourite_provider.dart';

const kInitialFilters = {filter.glutenfree: false, filter.lactoseFree: false};

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  Map<filter, bool> _selectedFilters = kInitialFilters;
  int _selectedpageindex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedpageindex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == "filters") {
      await Navigator.of(context).push<Map<filter, bool>>(
          MaterialPageRoute(builder: (ctx) => const FilterScreen()));
      // ignore: avoid_print
    }
  }

  @override
  Widget build(BuildContext context) {
    final availablemeals = ref.watch(filteredMealsProvider);
    Widget activePage = CategoriesScreen(
      availableMeals: availablemeals,
    );
    var activePageTitle = "Categories";

    if (_selectedpageindex == 1) {
      final favouriteMeals = ref.watch(favouriteMealsProvider);

      activePage = MealsScreen(
        title: "Favourites",
        meals: favouriteMeals,
      );
      activePageTitle = "Your Favourites";
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
