part of 'meal_controller_cubit.dart';

abstract class MealState {
  List<MealModel> meals = [];
  List<MealModel> mealsFilter = [];
  List<MealModel> mealsForRestaurant = [];
}

class DoneStateMeal extends MealState {
  DoneStateMeal({
    required List<MealModel> meals,
    required List<MealModel> mealsFilter,
    required List<MealModel> mealsForRestaurant,
  }) {
    this.meals = meals;
    this.mealsFilter = mealsFilter;
    this.mealsForRestaurant = mealsForRestaurant;
  }
}

class LoadingStateMeal extends MealState {}

class ErrorStateMeal extends MealState {}
