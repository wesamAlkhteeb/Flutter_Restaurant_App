class MealOrderModel {
  String name, pieces, image;

  MealOrderModel({
    required this.name,
    required this.pieces,
    required this.image,
  });

  @override
  String toString() {
    return 'MealOrderModel{name: $name, pieces: $pieces, image: $image}';
  }
}
