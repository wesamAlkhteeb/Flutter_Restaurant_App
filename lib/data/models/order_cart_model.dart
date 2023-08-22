class OrderCartModel {
  String priceOneMeal;
  String numberOfMeal;
  String id;
  String nameMeal;
  String imageUri;

  OrderCartModel({
    required this.id,
    required this.nameMeal,
    required this.priceOneMeal,
    required this.numberOfMeal,
    required this.imageUri,
  });

  @override
  String toString() {
    return 'OrderModel{ priceOneMeal: $priceOneMeal, numberOfMeal: $numberOfMeal, id: $id, nameMeal: $nameMeal, imageUri: $imageUri}';
  }
}
