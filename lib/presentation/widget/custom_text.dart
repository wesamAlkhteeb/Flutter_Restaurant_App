import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rest_app/bussiness_logic/theme_controller_cubit.dart';

class CustomText extends StatelessWidget {
  CustomText(
      {Key? key,
      required this.text,
      required this.typeStyle,
      this.fontWeight,
      this.color,
      this.size,
      this.isLongText = false,
      this.numberLine = 1,
      this.textAlign = TextAlign.start,
      this.width = 30})
      : super(key: key);

  String text;
  TypeStyle typeStyle;

  double? width = 20;
  bool? isLongText = false;

  FontWeight? fontWeight;
  Color? color;
  double? size = -1;
  int numberLine = 1;

  TextAlign? textAlign;

  TextStyle modifyStyle(TextStyle textStyle) {
    return textStyle.copyWith(
      color: color ?? textStyle.color,
      fontWeight: fontWeight ?? textStyle.fontWeight,
      fontSize: size != -1 ? size : textStyle.fontSize,
    );
  }

  TextStyle getStyle(ThemeControllerState state) {
    if (typeStyle is SubTitleText) {
      return modifyStyle(state.subTitleText!);
    } else if (typeStyle is SubTitleButton) {
      return modifyStyle(state.subTitleButton!);
    } else if (typeStyle is TitleButton) {
      return modifyStyle(state.titleButton!);
    } else if (typeStyle is RadioButton) {
      return modifyStyle(state.radioButton!);
    } else if (typeStyle is SmallText) {
      return modifyStyle(state.smallText!);
    } else if (typeStyle is TitleText) {
      return modifyStyle(state.titleText!);
    }
    return modifyStyle(state.smallText!);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeControllerCubit, ThemeControllerState>(
      builder: (ctx, state) {
        return isLongText!
            ? SizedBox(
                width: width!,
                child: Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                  style: getStyle(state),
                  maxLines: numberLine,
                  textAlign: textAlign,
                ),
              )
            : Text(
                text,
                style: getStyle(state),
                textAlign: textAlign,
              );
      },
    );
  }
}
