part of 'detail_order_controller_cubit.dart';

@immutable
abstract class DetailOrderControllerState {
  List<MealOrderModel> orders =[];
}

class DetailOrderControllerDone extends DetailOrderControllerState {
  DetailOrderControllerDone({required List<MealOrderModel> order }){
    super.orders = order;
  }
}
class DetailOrderControllerError extends DetailOrderControllerState {}
class DetailOrderControllerLoading extends DetailOrderControllerState {}
