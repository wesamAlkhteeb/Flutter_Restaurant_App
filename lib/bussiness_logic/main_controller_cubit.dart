import 'package:bloc/bloc.dart';

part 'main_controller_state.dart';

class MainControllerCubit extends Cubit<MainControllerState> {
  MainControllerCubit() : super(MealSection());

  changeIndexCategory({required MainControllerState categoryScreen}){
    emit(categoryScreen);
  }
}
