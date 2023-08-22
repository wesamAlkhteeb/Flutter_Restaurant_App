import 'package:flutter/material.dart';


class SizeConfig {
  static double? _screenWidth = 100;
  static double? _screenHeight = 100;

  SizeConfig({required double width , required double height}){
    _screenHeight = height;
    _screenWidth = width;
  }

  static getPercentHeight({required double percent}){
    return _screenHeight! * percent;
  }

  static getPercentWidth({required double percent}){
    return _screenWidth! * percent;
  }


}