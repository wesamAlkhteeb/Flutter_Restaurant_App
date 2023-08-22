import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rest_app/services/storage_services.dart';

class StarWebServices {
  final String idMeal = "ID_MEAL";
  final String idRestaurant = "ID_RESTAURANT";
  final String idUser = "ID_USER";
  final String starUser = "Star";

  final String collectionStarMeal = "StarMeal";
  final String collectionMeal = "Meals";
  final String collectionStarRestaurant = "StarRestaurant";
  final String collectionUser = "User";

  addEvaluationMeal(
      {required String idUser,
      required String idMeal,
      required double starUser}) async {
    FirebaseFirestore.instance.collection(collectionStarMeal);
    final resultStars = await FirebaseFirestore.instance
        .collection(collectionStarMeal)
        .where(
          this.idMeal,
          isEqualTo: idMeal,
        )
        .where(
          this.idUser,
          isEqualTo: idUser,
        )
        .get();

    if (resultStars.docs.isEmpty) {
      await FirebaseFirestore.instance.collection(collectionStarMeal).add({
        this.idMeal: idMeal,
        this.idUser: idUser,
        this.starUser: starUser,
      });
    } else {
      await FirebaseFirestore.instance
          .collection(collectionStarMeal)
          .doc(resultStars.docs[0].id)
          .update({
        this.starUser: starUser,
      });
    }

    double allStar = 0;
    final allStarList = await FirebaseFirestore.instance
        .collection(collectionStarMeal)
        .where(this.idMeal, isEqualTo: idMeal)
        .get();

    for (int i = 0; i < allStarList.docs.length; i++) {
      allStar += allStarList.docs[i].data()[this.starUser];
    }
    allStar /= allStarList.docs.length;
    await FirebaseFirestore.instance
        .collection(collectionMeal)
        .doc(idMeal)
        .update({this.starUser: allStar});
  }

  Future<void> addEvaluationRestaurant(
      {required String idUser,
      required String idRestaurant,
      required double starUser}) async {
    print("user");
    print(idUser);
    print("restaurant");
    print(idRestaurant);
    FirebaseFirestore.instance.collection(collectionStarMeal);
    final resultStars = await FirebaseFirestore.instance
        .collection(collectionStarRestaurant)
        .where(
          this.idRestaurant,
          isEqualTo: idRestaurant,
        )
        .where(
          this.idUser,
          isEqualTo: idUser,
        )
        .get();
    if (resultStars.docs.isEmpty) {
      await FirebaseFirestore.instance
          .collection(collectionStarRestaurant)
          .add({
        this.idRestaurant: idRestaurant,
        this.idUser: idUser,
        this.starUser: starUser,
      });
    } else {
      await FirebaseFirestore.instance
          .collection(collectionStarRestaurant)
          .doc(resultStars.docs[0].id)
          .update({
        this.starUser: starUser,
      });
    }

    double allStar = 0;
    final allStarList = await FirebaseFirestore.instance
        .collection(collectionStarRestaurant)
        .where(this.idRestaurant, isEqualTo: idRestaurant)
        .get();
    for (int i = 0; i < allStarList.docs.length; i++) {
      double a = allStarList.docs[i].data()[this.starUser];
      allStar += a;
    }
    allStar = allStarList.docs.isEmpty ? 1 : allStar / allStarList.docs.length;

    final restaurant = await FirebaseFirestore.instance
        .collection(collectionUser)
        .where("id", isEqualTo: idRestaurant)
        .get();
    await FirebaseFirestore.instance
        .collection(collectionUser)
        .doc(restaurant.docs[0].id)
        .update({
      this.starUser: double.parse(allStar.toStringAsFixed(1)),
    });
  }
}
