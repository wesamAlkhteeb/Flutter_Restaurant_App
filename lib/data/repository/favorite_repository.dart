

import 'package:rest_app/data/web_services/favorite_web_services.dart';

import '../models/resturant_model.dart';

class FavoriteRepository{

  FavoriteWebServices favoriteWebServices = FavoriteWebServices();

  Future<bool> saveRestaurantToFavorite(String idRestaurant)async{
    return await favoriteWebServices.saveRestaurantToFavorite(idRestaurant);
  }

  Future<bool> getStateFavorite(String idRestaurant )async{
    return await favoriteWebServices.getStateFavorite(idRestaurant);
  }

  Future<List<RestaurantModel>> getRestaurantFavorite() async {
    return favoriteWebServices.getRestaurantFavorite();
  }
}