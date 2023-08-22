

import 'package:rest_app/data/models/order_cart_model.dart';

class CartModel{
  String idRestaurant="";
  List<OrderCartModel> allOrder =[];

  CartModel({required this.idRestaurant ,required this.allOrder});

  @override
  String toString() {
    return 'CartModel{idRestaurant: $idRestaurant, allOrder: $allOrder}';
  }
}