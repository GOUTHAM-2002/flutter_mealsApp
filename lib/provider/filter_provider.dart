import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/provider/meals_provider.dart';

// ignore: camel_case_types
enum filter { glutenfree, lactoseFree }

class FiltersNotifier extends StateNotifier<Map<filter, bool>> {
  FiltersNotifier()
      : super({filter.glutenfree: false, filter.lactoseFree: false});

  void setFilter(filter filter, bool isActive) {
    state = {
      ...state,
      filter: isActive,
    };
  }

  void setFilters(Map<filter, bool> chosenFilters) {
    state = chosenFilters;
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<filter, bool>>(
        (ref) => FiltersNotifier());

final filteredMealsProvider = Provider((ref) {
  final meals = ref.watch(mealsProvider);
  final activeFilters = ref.watch(filtersProvider);
  return meals.where((element) {
    if (activeFilters[filter.glutenfree]! && !element.isGlutenFree) {
      return false;
    }
    if (activeFilters[filter.lactoseFree]! && !element.isLactoseFree) {
      return false;
    }
    return true;
  }).toList();
});
