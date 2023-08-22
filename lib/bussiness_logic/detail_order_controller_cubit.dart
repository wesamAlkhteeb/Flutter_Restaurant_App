import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rest_app/data/models/meal_order_model.dart';
import 'package:rest_app/data/repository/order_repository.dart';

part 'detail_order_controller_state.dart';

class DetailOrderControllerCubit extends Cubit<DetailOrderControllerState> {
  DetailOrderControllerCubit() : super(DetailOrderControllerDone(order: const []));

  final OrderRepository _orderRepository = OrderRepository();

  Future getDetailOrder({required String idOrder})async{
    emit(DetailOrderControllerLoading());

    await _orderRepository.getDetailOrder(idOrder: idOrder).then((value) {

      emit(DetailOrderControllerDone(order: value));
    }).onError((error, stackTrace) {
      emit(DetailOrderControllerError());
    });
  }
}
