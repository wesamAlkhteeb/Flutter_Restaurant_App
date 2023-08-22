class RestaurantModel {
  final String id, name, address, image;
  final double rating;

  @override
  String toString() {
    return 'RestaurantModel{id: $id, name: $name, address: $address, image: $image, rating: $rating}';
  }

  RestaurantModel({
    required this.id,
    required this.name,
    required this.address,
    required this.image,
    required this.rating,
  });
}
