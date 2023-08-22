import 'package:bloc/bloc.dart';
import 'package:rest_app/data/models/account_model.dart';
import 'package:rest_app/data/models/meal_model.dart';
import 'package:rest_app/data/repository/meal_repository.dart';
import 'package:rest_app/data/web_services/authentication/state_Account.dart';
import 'package:rest_app/data/web_services/meal_web_services.dart';
import 'package:rest_app/presentation/screen/add_and_update_meal/add_update_meal.dart';

part 'meal_controller_state.dart';

class MealControllerCubit extends Cubit<MealState> {
  MealControllerCubit()
      : super(DoneStateMeal(
          meals: [],
          mealsFilter: [],
          mealsForRestaurant: [],
        )) {
    mealRepository = MealRepository();
  }

  MealRepository? mealRepository;

  String search = "";

  changeListFilter() {
    if (state is DoneStateMeal) {
      MealState mealState = state;
      mealState.mealsFilter = mealState.meals.where((element) {
        return element.title.contains(search);
      }).toList();
      emit(DoneStateMeal(
        meals: state.meals,
        mealsForRestaurant: state.mealsForRestaurant,
        mealsFilter: mealState.mealsFilter,
      ));
    }
  }

  // fetch meal
  getAllMeal({required StateFetch stateFetch}) async {
    DoneStateMeal? doneStateMeal = DoneStateMeal(
      meals: [],
      mealsFilter: [],
      mealsForRestaurant: [],
    );
    if (state is DoneStateMeal) {
      doneStateMeal.meals = state.meals;
      doneStateMeal.mealsForRestaurant = state.mealsForRestaurant;
    }
    emit(LoadingStateMeal());
    await mealRepository!
        .getMeal(
      stateFetch: stateFetch,
    )
        .then((value) {
      if (stateFetch is AllMealFetch) {
        doneStateMeal.meals = value;
        doneStateMeal.meals.sort((a, b) {
          return a.rating > b.rating ? 0 : 1;
        });
        doneStateMeal.mealsFilter = doneStateMeal.meals;
      } else {
        doneStateMeal.mealsForRestaurant = value;
      }
      emit(doneStateMeal);
      return;
    }).onError((error, stackTrace) {
      emit(ErrorStateMeal());
    });
  }

  // add meal
  MealModel mealModel = MealModel(
      id: "",
      title: "",
      description: "",
      image: "",
      rating: 0,
      price: "",
      nameRestaurant: "");

  changeData({required InputMealData inputMealData, required String data}) {
    if (inputMealData is NameInputMealData) {
      mealModel.title = data;
    } else if (inputMealData is DescriptionInputMealData) {
      mealModel.description = data;
    } else if (inputMealData is PriceInputMealData) {
      mealModel.price = data;
    } else if (inputMealData is ImageInputMealData) {
      mealModel.image = data;
    } else if (inputMealData is IDInputMealData) {
      mealModel.id = data;
    }
  }

  String checkAllInputText(TypeOperationMealScreen typeOperationMealScreen) {
    if (mealModel.title.isEmpty) {
      return "Please Enter Name Meal";
    }
    if (mealModel.title.length < 4 || mealModel.title.length >= 20) {
      return "The length username meal must be between 4 ,20 .";
    }
    if (mealModel.description.isEmpty) {
      return "Please Enter description Meal";
    }
    if (mealModel.description.length < 4 ||
        mealModel.description.length >= 100) {
      return "The length description meal must be between 4 ,100 .";
    }
    if (mealModel.price.isEmpty) {
      return "Please Enter Price Meal";
    }
    if (mealModel.price.length >= 6) {
      return "new you are present gold. please change to less price.";
    }
    if (mealModel.image.isEmpty &&
        typeOperationMealScreen is AddMealOperation) {
      return "Please Select Image Meal";
    }
    return "";
  }

  Future<ResponseMessageData?> addMeal() async {
    return await mealRepository?.addMeal(mealModel: mealModel);
  }

  Future<ResponseMessageData?> updateMeal() async {
    return await mealRepository?.updateMeal(mealModel: mealModel);
  }

  Future<ResponseMessageData?> updateImageMeal(
      {required String idMeal, required String path}) async {
    return await mealRepository?.updateImageMeal(idMeal: idMeal, path: path);
  }

  Future<ResponseMessageData?> deleteMeal({required String idMeal}) async {
    return await mealRepository?.deleteMeal(idMeal: idMeal);
  }
}

abstract class InputMealData {}

class NameInputMealData extends InputMealData {}

class DescriptionInputMealData extends InputMealData {}

class PriceInputMealData extends InputMealData {}

class ImageInputMealData extends InputMealData {}

class IDInputMealData extends InputMealData {}
