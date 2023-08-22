

import 'package:rest_app/data/models/meal_model.dart';
import 'package:rest_app/data/web_services/authentication/state_Account.dart';
import 'package:rest_app/data/web_services/meal_web_services.dart';

import '../web_services/meal_web_services.dart';


class MealRepository{
  MealWebServices? mealWebServices ;
  MealRepository(){
    mealWebServices = MealWebServices();
  }

  Future<List<MealModel>> getMeal({required StateFetch stateFetch})async{
    return await mealWebServices!.fetchAllMeal(stateFetch: stateFetch);
  }

  Future<ResponseMessageData?> addMeal ({required MealModel mealModel})async{
    return await mealWebServices?.addMeal(mealModel: mealModel);
  }


  Future<ResponseMessageData?> updateMeal({required MealModel mealModel}) async {
    return await mealWebServices?.updateMeal(mealModel: mealModel);
  }


  Future<ResponseMessageData?> updateImageMeal({required String idMeal , required String path})async{
    return await mealWebServices?.updateImageMeal(idMeal :idMeal , path:path);
  }

  Future<ResponseMessageData?> deleteMeal(
      {required String idMeal,}) async {
    return await mealWebServices?.deleteMeal(idMeal :idMeal);

  }

}