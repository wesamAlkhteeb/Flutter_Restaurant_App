import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rest_app/data/models/account_model.dart';
import 'package:rest_app/data/models/resturant_model.dart';

class RestaurantWebServices {
  Future<List<RestaurantModel>> fetchAllRestaurant() async {
    List<RestaurantModel> allRestaurant = [];
    try {
      final responseRestaurant = await FirebaseFirestore.instance
          .collection("User")
          .where("typeOfAccount", isEqualTo: ChiefAccount().type)
          .get();
      responseRestaurant.docs.forEach((restaurant) {
        RestaurantModel restaurantModel = RestaurantModel(
          id: restaurant["id"],
          name: restaurant["username"],
          address: restaurant["address"],
          image: restaurant["frontImage"],
          rating: double.parse("${ restaurant["Star"]}"),
        );
        allRestaurant.add(
          restaurantModel,
        );
      });
    } catch (e) {
      print(e);
      throw Exception(e);
    }
    return allRestaurant;
  }
}
