import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rest_app/data/models/meal_model.dart';
import 'package:rest_app/data/web_services/authentication/state_Account.dart';
import 'package:rest_app/services/storage_services.dart';

class MealWebServices {
  Future<List<MealModel>> fetchAllMeal({required StateFetch stateFetch}) async {
    try {
      List<MealModel> meals = [];
      if (stateFetch is AllMealFetch) {
        await FirebaseFirestore.instance
            .collection("Meals")
            .get()
            .then((value) async {
          for (int i = 0; i < value.docs.length; i++) {
            String nameRestaurant = "";
            await FirebaseFirestore.instance
                .collection("User")
                .where("id", isEqualTo: value.docs[i].data()["id"])
                .get()
                .then((value) {
              if (value.docs.isNotEmpty) {
                nameRestaurant = value.docs[0].data()["username"];
              }
            });
            meals.add(
              MealModel.fromJson(
                value.docs[i].data(),
                value.docs[i].id,
                nameRestaurant,
              ),
            );
          }
        });
      }else if (stateFetch is AllMealForRestaurantFetch) {
        await FirebaseFirestore.instance
            .collection("Meals")
            .where("id",
                isEqualTo: StorageServices.getInstance()
                    .loadData(key: TokenKeyStorage()))
            .get()
            .then((value) async {
          for (int i = 0; i < value.docs.length; i++) {
            String nameRestaurant = "";
            await FirebaseFirestore.instance
                .collection("User")
                .where("id", isEqualTo: value.docs[i].data()["id"])
                .get()
                .then((value) {
              if (value.docs.isNotEmpty) {
                nameRestaurant = value.docs[0].data()["username"];
              }
            });
            meals.add(
              MealModel.fromJson(
                value.docs[i].data(),
                value.docs[i].id,
                nameRestaurant,
              ),
            );
          }
        });
      } else if (stateFetch is AllMealForRestaurantUserFetch) {
        await FirebaseFirestore.instance
            .collection("Meals")
            .where("id", isEqualTo: stateFetch.idRestaurant)
            .get()
            .then((value) async {
          for (int i = 0; i < value.docs.length; i++) {
            String nameRestaurant = "";
            await FirebaseFirestore.instance
                .collection("User")
                .where("id", isEqualTo: value.docs[i].data()["id"])
                .get()
                .then((value) {
              if (value.docs.isNotEmpty) {
                nameRestaurant = value.docs[0].data()["username"];
              }
            });
            meals.add(
              MealModel.fromJson(
                value.docs[i].data(),
                value.docs[i].id,
                nameRestaurant,
              ),
            );
          }
        });
      }
      return meals;
    } catch (e) {

      throw Exception(e);
    }
  }

  Future<ResponseMessageData> addMeal({required MealModel mealModel}) async {
    try {
      File file = File(mealModel.image);
      String basename = (mealModel.image.split("/").last).split(".").first;
      final ref = FirebaseStorage.instance
          .ref("Meals/$basename${Random().nextInt(10000)}");
      await ref.putFile(file);

      await FirebaseFirestore.instance.collection("Meals").add({
        "title": mealModel.title,
        "image": await ref.getDownloadURL(),
        "price": mealModel.price,
        "Star": 1.0,
        "description": mealModel.description,
        "id": StorageServices.getInstance().loadData(key: TokenKeyStorage()),
      });
      return ResponseMessageData(
          "Add Meal has been successfully", StateResponse.successfully);
    } catch (e) {
      return ResponseMessageData("Added error", StateResponse.error);
    }
  }

  Future<ResponseMessageData> updateMeal({required MealModel mealModel}) async {
    try {
      await FirebaseFirestore.instance
          .collection("Meals")
          .doc(mealModel.id)
          .update({
        "price": mealModel.price,
        "description": mealModel.description,
        "title": mealModel.title,
      });

      return ResponseMessageData(
          "update has been successfully", StateResponse.successfully);
    } catch (e) {
      return ResponseMessageData("error in update name", StateResponse.error);
    }
  }

  Future<ResponseMessageData?> updateImageMeal(
      {required String idMeal, required String path}) async {
    try {
      File file = File(path);
      String basename = (path.split("/").last).split(".").first;
      final ref = FirebaseStorage.instance
          .ref("Users/$basename${Random().nextInt(10000)}");
      await ref.putFile(file);

      final a = await FirebaseFirestore.instance
          .collection("Meals")
          .doc(idMeal)
          .get();
      String deletePath = a.data()!["image"];

      await FirebaseStorage.instance.refFromURL(deletePath).delete();

      await FirebaseFirestore.instance.collection("Meals").doc(idMeal).update({
        "image": await ref.getDownloadURL(),
      });

      return ResponseMessageData(
          "update image has been successfully", StateResponse.successfully);
    } catch (e) {
      return ResponseMessageData(
          "error in update image meal", StateResponse.error);
    }
  }

  Future<ResponseMessageData?> deleteMeal({
    required String idMeal,
  }) async {
    try {
      final a = await FirebaseFirestore.instance
          .collection("Meals")
          .doc(idMeal)
          .get();
      String deletePath = a.data()!["image"];
      await FirebaseStorage.instance.refFromURL(deletePath).delete();

      await FirebaseFirestore.instance.collection("Meals").doc(idMeal).delete();

      return ResponseMessageData(
          "delete meal has been successfully", StateResponse.successfully);
    } catch (e) {
      throw Exception(e);
      return ResponseMessageData("error in delete meal", StateResponse.error);
    }
  }
}

abstract class StateFetch {
  String idRestaurant = "";
}

class AllMealFetch extends StateFetch {}
class StarMealFetch extends StateFetch {}

class AllMealForRestaurantFetch extends StateFetch {}

// فاتح حساب يوزر وعم جيب كل الوجبات هون بحتاج أخد id مطعم
class AllMealForRestaurantUserFetch extends StateFetch {
  AllMealForRestaurantUserFetch({required idRestaurant}) {
    super.idRestaurant = idRestaurant;
  }
}
