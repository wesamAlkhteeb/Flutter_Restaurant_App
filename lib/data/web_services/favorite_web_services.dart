import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rest_app/bussiness_logic/restaurants_controller_cubit.dart';
import 'package:rest_app/data/models/resturant_model.dart';
import 'package:rest_app/services/storage_services.dart';

class FavoriteWebServices {
  final String idUser = "id_user";
  final String idRestaurant = "id_restaurant";

  Future<bool> saveRestaurantToFavorite(String idRes) async {
    try {
      final favoriteRestaurant = await FirebaseFirestore.instance
          .collection("favorite")
          .where(idUser,
              isEqualTo: StorageServices.getInstance()
                  .loadData(key: TokenKeyStorage()))
          .where(idRestaurant, isEqualTo: idRes)
          .get();
      if (favoriteRestaurant.docs.isEmpty) {
        await FirebaseFirestore.instance.collection("favorite").add({
          idUser:
              StorageServices.getInstance().loadData(key: TokenKeyStorage()),
          idRestaurant: idRes
        });
      } else {
        await FirebaseFirestore.instance
            .collection("favorite")
            .doc(favoriteRestaurant.docs[0].id)
            .delete();
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  getStateFavorite(String idRes) async {
    try {
      final favoriteRestaurant = await FirebaseFirestore.instance
          .collection("favorite")
          .where(idUser,
              isEqualTo: StorageServices.getInstance()
                  .loadData(key: TokenKeyStorage()))
          .where(idRestaurant, isEqualTo: idRes)
          .get();

      if (favoriteRestaurant.docs.isEmpty) {
        return false;
      }
      return true;
    } catch (e) {
      print(e);
    }
  }

  Future<List<RestaurantModel>> getRestaurantFavorite() async {
    List<RestaurantModel> restaurants = [];
    try {
      final favoriteRestaurant = await FirebaseFirestore.instance
          .collection("favorite")
          .where(idUser,
              isEqualTo: StorageServices.getInstance()
                  .loadData(key: TokenKeyStorage()))
          .get();
      for (int i = 0; i < favoriteRestaurant.docs.length; i++) {
        final restaurant = await FirebaseFirestore.instance
            .collection("User")
            .where(
              "id",
              isEqualTo: favoriteRestaurant.docs[i][idRestaurant],
            )
            .get();
        restaurants.add(
          RestaurantModel(
            id: restaurant.docs[0]["id"],
            name: restaurant.docs[0]["username"],
            address: restaurant.docs[0]["address"],
            image: restaurant.docs[0]["frontImage"],
            rating: restaurant.docs[0]["Star"],
          ),
        );
      }
      return restaurants;
    } catch (e) {
      print(e);
      return [];
    }
  }
}
