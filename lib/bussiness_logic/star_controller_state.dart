part of 'star_controller_cubit.dart';

@immutable
abstract class StarControllerState {
  int star=0;
}

class StarControllerReload extends StarControllerState {
  StarControllerReload({required int star}){
    super.star = star;
  }
}

class StarControllerDone  extends StarControllerState {
  StarControllerDone({required int star}){
    super.star = star;
  }
}
