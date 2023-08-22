part of 'theme_controller_cubit.dart';

@immutable
abstract class ThemeControllerState {
  ThemeData? themeData;
  TextStyle? subTitleText ;
  TextStyle? titleText ;
  TextStyle? subTitleButton ;
  TextStyle? titleButton ;
  TextStyle? radioButton ;
  TextStyle? smallText ;
}

class LightTheme extends ThemeControllerState {
  LightTheme() {
    themeData = appThemeData[AppTheme.light]!;
    subTitleText = GoogleFonts.lato(
      textStyle: TextStyle(
        color: Colors.black87,
        fontSize: SizeConfig.getPercentWidth(percent: .18),
        fontWeight: FontWeight.w500,
      ),
    );
    titleText = GoogleFonts.lato(
      textStyle: TextStyle(
        color: Colors.black87,
        fontSize: SizeConfig.getPercentWidth(percent: .24),
        fontWeight: FontWeight.w700,
      ),
    );
    radioButton = GoogleFonts.lato(
      textStyle: TextStyle(
        color: Colors.black87,
        fontSize: SizeConfig.getPercentWidth(percent: .1),
        fontWeight: FontWeight.w500,
      ),
    );
    subTitleButton = GoogleFonts.lato(
      textStyle: TextStyle(
        color: themeData!.primaryColor,
        fontSize: SizeConfig.getPercentWidth(percent: .2),
        fontWeight: FontWeight.w700,
      ),
    );
    titleButton = GoogleFonts.lato(
      textStyle: TextStyle(
        color: Colors.white,
        fontSize: SizeConfig.getPercentWidth(percent: .25),
        fontWeight: FontWeight.w700,
      ),
    );

    smallText = GoogleFonts.lato(
      textStyle: TextStyle(
        color: Colors.white,
        fontSize: SizeConfig.getPercentWidth(percent: .14),
      ),
    );

  }
}

class DarkTheme extends ThemeControllerState {
  DarkTheme() {
    themeData = appThemeData[AppTheme.dark];
    titleText = GoogleFonts.lato(
      textStyle: TextStyle(
        color: Colors.black87,
        fontSize: SizeConfig.getPercentWidth(percent: .18),
        fontWeight: FontWeight.w500,
      ),
    );
    subTitleText = GoogleFonts.lato(
      textStyle: TextStyle(
        color: Colors.white ,
        fontSize: SizeConfig.getPercentWidth(percent: .06),
        fontWeight: FontWeight.w700,
      ),
    );
    radioButton = GoogleFonts.lato(
      textStyle: TextStyle(
        color: Colors.black87,
        fontSize: SizeConfig.getPercentWidth(percent: .1),
        fontWeight: FontWeight.w500,
      ),
    );
    subTitleButton = GoogleFonts.lato(
      textStyle: TextStyle(
        color: Colors.black87,
        fontSize: SizeConfig.getPercentWidth(percent: .18),
        fontWeight: FontWeight.w500,
      ),
    );
    titleButton = GoogleFonts.lato(
      textStyle: TextStyle(
        color: themeData!.primaryColor,
        fontSize: SizeConfig.getPercentWidth(percent: .2),
        fontWeight: FontWeight.w700,
      ),
    );
    smallText = GoogleFonts.lato(
      textStyle: TextStyle(
        color: Colors.white,
        fontSize: SizeConfig.getPercentWidth(percent: .14),
      ),
    );
  }
}


abstract class TypeStyle{}
class SubTitleText extends TypeStyle{}
class TitleText extends TypeStyle{}
class SubTitleButton extends TypeStyle{}
class TitleButton extends TypeStyle{}
class RadioButton extends TypeStyle{}
class SmallText extends TypeStyle{}