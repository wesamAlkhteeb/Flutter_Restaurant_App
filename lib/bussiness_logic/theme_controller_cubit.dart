import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meta/meta.dart';
import 'package:rest_app/constant/size_config.dart';
import 'package:rest_app/constant/themes.dart';

part 'theme_controller_state.dart';

class ThemeControllerCubit extends Cubit<ThemeControllerState> {
  ThemeControllerCubit() : super(LightTheme());


  changeThemeData(String appTheme) {
    switch (appTheme) {
      case AppTheme.light:
        {
          emit(LightTheme());
          break;
        }
      case AppTheme.dark:
        {
          emit(DarkTheme());
          break;
        }
    }
  }

  isLightMode(){
    if(state is LightTheme) {
      return true ;
    } else {
      return false;
    }

  }

}
