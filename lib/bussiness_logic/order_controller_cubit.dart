import 'package:bloc/bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:meta/meta.dart';
import 'package:rest_app/data/models/order_cart.dart';
import 'package:rest_app/data/repository/order_repository.dart';
import 'package:rest_app/services/storage_services.dart';

part 'order_controller_state.dart';

class OrderControllerCubit extends Cubit<OrderControllerState> {
  OrderControllerCubit()
      : super(OrderControllerDone(haveOrder: const [], newOrders: const []));

  final OrderRepository _orderRepository = OrderRepository();

  bool choose = false;

  changeChoose(bool ch) {
    choose = ch;
    emit(OrderControllerDone(
        newOrders: state.newOrders, haveOrder: state.haveOrders));
  }

  Future getOrdersForChief() async {
    emit(OrderControllerLoading());
    await _orderRepository.getOrdersForChief().then((value) {
      emit(OrderControllerDone(
        haveOrder: value
            .where((element) => element.state != NewOrderState().state)
            .toList(),
        newOrders: value
            .where((element) => element.state == NewOrderState().state)
            .toList(),
      ));
    }).onError((error, stackTrace) {
      emit(OrderControllerError());
    });
  }

  Future getOrdersForUser() async {
    emit(OrderControllerLoading());
    await _orderRepository.getOrdersForUser().then((value) {
      emit(OrderControllerDone(
        haveOrder: value,
        newOrders: value,
      ));
    }).onError((error, stackTrace) {
      emit(OrderControllerError());
    });
  }

  Future changeState(
      {required OrderState orderState, required String idOrder}) async {
    OrderControllerState orderControllerState = state;
    emit(OrderControllerLoading());

    await _orderRepository.changeState(orderState: orderState, idOrder: idOrder).then((value) {
      emit(orderControllerState);
    }).onError((error, stackTrace) {
      emit(OrderControllerError());
    });
    getOrdersForChief();
  }

  Future deleteOrder({required String idOrder}) async {
    emit(OrderControllerLoading());
    await _orderRepository.deleteOrder(idOrder: idOrder);
    if(StorageServices.getInstance().loadData(key: TypeKeyStorage()) == "User"){
      await getOrdersForUser();
    }else{
      await getOrdersForChief();
    }
  }
}

abstract class OrderState {
  String _state = "";

  String get state => _state;
}

class NewOrderState extends OrderState {
  NewOrderState() {
    _state = "NEW";
  }
}

class AcceptOrderState extends OrderState {
  AcceptOrderState() {
    _state = "ACCEPT";
  }
}

class FinishOrderState extends OrderState {
  FinishOrderState() {
    _state = "FINISH";
  }
}
