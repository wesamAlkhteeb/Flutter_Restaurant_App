class MealModel {
  String id;
  String title, description, image, price;
  double rating;
  String nameRestaurant;

  MealModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.rating,
    required this.price,
    required this.nameRestaurant,
  });

  factory MealModel.fromJson(
      Map<String, dynamic> json, String id, String nameRestaurant) {
    return MealModel(
      id: id,
      title: json["title"],
      description: json["description"],
      image: json["image"],
      price: json["price"],
      rating: double.parse("${json["Star"]}"),
      nameRestaurant: nameRestaurant,
    );
  }

  @override
  String toString() {
    return 'title: $title,';
  }
}
