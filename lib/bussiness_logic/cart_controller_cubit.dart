import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rest_app/data/models/cart_model.dart';
import 'package:rest_app/data/models/order_cart_model.dart';
import 'package:rest_app/data/repository/order_repository.dart';

part 'cart_controller_state.dart';

final CartModel cartModel = CartModel(idRestaurant: "", allOrder: []);

class CartControllerCubit extends Cubit<CartControllerState> {
  CartControllerCubit() : super(CartControllerDone());

  addIdRestaurant({required String idRestaurant}) {
    if (cartModel.idRestaurant.isEmpty || cartModel.allOrder.isEmpty) {
      cartModel.idRestaurant = idRestaurant;
    }
  }

  checkChoose({required String idRestaurant}) {
    return cartModel.idRestaurant != idRestaurant &&
        cartModel.allOrder.isNotEmpty;
  }

  addMealToOrder(
      {required String id,
      required String nameMeal,
      required String priceOneMeal,
      required String imageUri}) {
    int index = 0;
    for (; index < cartModel.allOrder.length; index++) {
      if (cartModel.allOrder[index].id == id) {
        break;
      }
    }
    if (index < cartModel.allOrder.length) {
      cartModel.allOrder[index].numberOfMeal =
          (int.parse(cartModel.allOrder[index].numberOfMeal) + 1).toString();
    } else {
      cartModel.allOrder.add(
        OrderCartModel(
            id: id,
            nameMeal: nameMeal,
            priceOneMeal: priceOneMeal,
            numberOfMeal: "1",
            imageUri: imageUri),
      );
    }
    emit(CartControllerDone());
  }

  minusMealToOrder(
      {required String id,
      required String nameMeal,
      required String priceOneMeal}) {
    int index = 0;
    for (; index < cartModel.allOrder.length; index++) {
      if (cartModel.allOrder[index].id == id) {
        break;
      }
    }
    if (index < cartModel.allOrder.length) {
      if (cartModel.allOrder[index].numberOfMeal == "1") {
        removeFormCart(index: index);
      } else {
        cartModel.allOrder[index].numberOfMeal =
            (int.parse(cartModel.allOrder[index].numberOfMeal) - 1).toString();
      }
    }
    emit(CartControllerDone());
  }

  String getNumberForMeal({required String id}) {
    int index = 0;
    for (; index < cartModel.allOrder.length; index++) {
      if (cartModel.allOrder[index].id == id) {
        break;
      }
    }
    return index < cartModel.allOrder.length
        ? cartModel.allOrder[index].numberOfMeal
        : "0";
  }

  getSumPrice() {
    double sum = 0;
    for (int i = 0; i < cartModel.allOrder.length; i++) {
      sum += (double.parse(cartModel.allOrder[i].priceOneMeal) *
          double.parse(cartModel.allOrder[i].numberOfMeal));
    }
    return sum.toStringAsFixed(2);
  }

  addFromCart({required int index}) {
    if (int.parse(cartModel.allOrder[index].numberOfMeal) == 1) {
      removeFormCart(index: index);
    } else {
      cartModel.allOrder[index].numberOfMeal =
          (int.parse(cartModel.allOrder[index].numberOfMeal) - 1).toString();
    }
    emit(CartControllerDone());
  }

  minusFromCart({required int index}) {
    cartModel.allOrder[index].numberOfMeal =
        (int.parse(cartModel.allOrder[index].numberOfMeal) + 1).toString();
    emit(CartControllerDone());
  }

  removeFormCart({required int index}) {
    cartModel.allOrder.removeAt(index);
  }

  clearOrders() {
    cartModel.allOrder = [];
    emit(CartControllerDone());
  }

  final OrderRepository _orderRepository = OrderRepository();

  Future<String> checkOutCart() async {
    return await _orderRepository.addOrder(cartModel: cartModel);
  }
}
