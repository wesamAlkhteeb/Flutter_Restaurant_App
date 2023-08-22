import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rest_app/data/models/resturant_model.dart';
import 'package:rest_app/data/repository/favorite_repository.dart';

part 'favorite_controller_state.dart';

class FavoriteControllerCubit extends Cubit<FavoriteControllerState> {
  FavoriteControllerCubit() : super(FavoriteControllerDone());

  FavoriteRepository favoriteRepository = FavoriteRepository();

  bool isFavorite = false;

  saveRestaurantToFavorite(String idRestaurant) async {
    emit(FavoriteControllerLoading());
    return await favoriteRepository.saveRestaurantToFavorite(idRestaurant).then((value) {
      isFavorite = !isFavorite;
      emit(FavoriteControllerDone());
    }).onError((error, stackTrace) {
      emit(FavoriteControllerError());
    });
  }

  getStateFavorite(String idRestaurant) async {
    emit(FavoriteControllerLoading());
    isFavorite =
    await favoriteRepository.getStateFavorite(idRestaurant).onError((error,
        stackTrace) {
      emit(FavoriteControllerError());
      return false;
    }).then((value) {
      emit(FavoriteControllerDone());
      return value;
    });
  }

  List<RestaurantModel> restaurantFavorite = [];
  getRestaurantFavorite() async {
    restaurantFavorite = [];
    emit(FavoriteControllerLoading());
    isFavorite =
    await favoriteRepository.getRestaurantFavorite().onError((error,
        stackTrace) {
      emit(FavoriteControllerError());
      return [];
    }).then((value) {
      restaurantFavorite = value;
      emit(FavoriteControllerDone());
      return true;
    });
  }
}
