

import 'package:rest_app/data/models/resturant_model.dart';
import 'package:rest_app/data/web_services/restaurant_web_services.dart';

class RestaurantRepository{
  RestaurantWebServices? _restaurantWebServices ;
  RestaurantRepository(){
    _restaurantWebServices = RestaurantWebServices();
  }

  Future<List<RestaurantModel>> fetchAllRestaurant() async {
    return await _restaurantWebServices!.fetchAllRestaurant();
  }
}