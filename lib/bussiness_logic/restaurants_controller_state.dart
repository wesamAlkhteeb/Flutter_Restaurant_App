part of 'restaurants_controller_cubit.dart';

@immutable
abstract class RestaurantsControllerState {
  List<RestaurantModel> allRestaurant =[];
  List<RestaurantModel> allRestaurantFilter =[];
}

class RestaurantDoneState extends RestaurantsControllerState{
  RestaurantDoneState({required List<RestaurantModel> allRestaurant ,required List<RestaurantModel> allRestaurantFilter ,}){
    super.allRestaurant = allRestaurant;
    super.allRestaurantFilter = allRestaurantFilter;
  }
}
class RestaurantLoadingState extends RestaurantsControllerState{}
class RestaurantErrorState extends RestaurantsControllerState{}