import 'package:flutter/material.dart';

class AppTheme{
  static const light = "light";
  static const dark = "dark";
}

const kPrimaryColor=Colors.amber;
const kSecondaryColor=Colors.amberAccent;
const kGrayColor=Color(0x5B5B5241);
const kWhiteColor=Color(0xffffffff);
const kTextGrayColor=Color(0xff262626);


final appThemeData = {
  AppTheme.light: ThemeData(
    primaryColor: kPrimaryColor,
    backgroundColor: Colors.white,
    brightness: Brightness.light,
  ),
  AppTheme.dark: ThemeData(
    primaryColor: Colors.black,
    backgroundColor: Colors.white,
    brightness: Brightness.light,
  ),
};


