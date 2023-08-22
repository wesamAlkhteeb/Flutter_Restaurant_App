import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rest_app/data/repository/star_repository.dart';

part 'star_controller_state.dart';

class StarControllerCubit extends Cubit<StarControllerState> {
  StarControllerCubit() : super(StarControllerReload(star: 0));
  StarRepository starRepository = StarRepository();

  changeStar(int star){
    emit(StarControllerDone(star: star));
  }

  Future<void> addEvaluationMeal({required String idUser,required String idMeal,required double starUser})async {
    await starRepository.addEvaluationMeal(idUser: idUser, idMeal: idMeal, starUser: starUser);
  }

  Future<void> addEvaluationRestaurant({required String idUser,required String idRestaurant,required double starUser})async {
    await starRepository.addEvaluationRestaurant(idUser: idUser, idRestaurant: idRestaurant, starUser: starUser);
  }

}
