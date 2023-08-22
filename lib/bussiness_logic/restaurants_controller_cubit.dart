import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rest_app/data/models/resturant_model.dart';
import 'package:rest_app/data/repository/restaurnat_respository.dart';

part 'restaurants_controller_state.dart';

class RestaurantsControllerCubit extends Cubit<RestaurantsControllerState> {
  RestaurantRepository? _restaurantRepository;

  RestaurantsControllerCubit()
      : super(RestaurantDoneState(allRestaurant: [], allRestaurantFilter: [])) {
    _restaurantRepository = RestaurantRepository();
  }

  String search = "";

  changeListFilter() {
    if (state is RestaurantDoneState) {
      RestaurantsControllerState restaurantsControllerState = state;
      restaurantsControllerState.allRestaurantFilter =
          restaurantsControllerState.allRestaurant.where((element) {
        return element.name.contains(search);
      }).toList();
      emit(RestaurantDoneState(
          allRestaurant: restaurantsControllerState.allRestaurant,
          allRestaurantFilter: restaurantsControllerState.allRestaurantFilter));
    }
  }

  fetchAllRestaurant() {
    emit(RestaurantLoadingState());
    _restaurantRepository!.fetchAllRestaurant().then((value) {
      emit(
        RestaurantDoneState(allRestaurant: value, allRestaurantFilter: value),
      );
    }).onError((error, stackTrace) {
      emit(RestaurantErrorState());
    });
  }

  List<RestaurantModel> allRestaurantList() => state.allRestaurantFilter;
}
