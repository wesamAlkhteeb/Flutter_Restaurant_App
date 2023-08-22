

import 'package:rest_app/data/web_services/star_web_services.dart';

class StarRepository {
  StarWebServices services = StarWebServices();

  addEvaluationMeal({required String idUser,required String idMeal,required double starUser })async{
    return await services.addEvaluationMeal(idUser: idUser, idMeal: idMeal, starUser: starUser);
  }


  Future<void> addEvaluationRestaurant({required String idUser,required String idRestaurant,required double starUser})async {
    await services.addEvaluationRestaurant(idUser: idUser, idRestaurant: idRestaurant, starUser: starUser);
  }

}