part of 'order_controller_cubit.dart';


@immutable
abstract class OrderControllerState {
  List<OrderModel> newOrders = [];
  List<OrderModel> haveOrders = [];
}

class OrderControllerDone extends OrderControllerState {
  OrderControllerDone({required List<OrderModel> newOrders , required List<OrderModel> haveOrder  }){
    super.newOrders = newOrders ;
    super.haveOrders = haveOrder;
  }
}
class OrderControllerError extends OrderControllerState {}
class OrderControllerLoading extends OrderControllerState {}
