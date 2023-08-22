

import 'package:rest_app/bussiness_logic/order_controller_cubit.dart';
import 'package:rest_app/data/models/cart_model.dart';
import 'package:rest_app/data/models/meal_order_model.dart';
import 'package:rest_app/data/models/order_cart.dart';
import 'package:rest_app/data/web_services/order_web_services.dart';

class OrderRepository{
  OrderWebServices orderWebServices = OrderWebServices();

  Future<String> addOrder({required CartModel cartModel})async{
      return await orderWebServices.addOrder(cartModel: cartModel);
  }

  Future<List<OrderModel>> getOrdersForChief ()async{
    return await orderWebServices.getOrdersForChief();
  }
  Future<List<OrderModel>> getOrdersForUser ()async{
    return await orderWebServices.getOrdersForUser();
  }



  Future<List<MealOrderModel>> getDetailOrder({required String idOrder})async{
    return await orderWebServices.getDetailOrder(idOrder: idOrder);
  }

  Future<void> changeState({required OrderState orderState ,required String idOrder})async{
    await orderWebServices.changeState(orderState: orderState,idOrder: idOrder);
  }

  Future deleteOrder({required String idOrder})async{
    await orderWebServices.deleteOrder(idOrder: idOrder);
  }

}