import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rest_app/bussiness_logic/text_field_controller_cubit.dart';
import 'package:rest_app/bussiness_logic/theme_controller_cubit.dart';
import 'package:rest_app/constant/themes.dart';

class CustomTextField extends StatefulWidget {
  CustomTextField({
    Key? key,
    required this.hintText,
    required this.onchange,
    required this.typeStyle,
    this.fontWeight = FontWeight.w500,
    this.color = Colors.grey,
    this.size = 20,
    this.textInputType = TextInputType.name,
    this.textEditingController,
  }) : super(key: key);

  TextEditingController? textEditingController;

  String hintText;
  Function(String?) onchange;

  TypeStyle typeStyle;
  TextInputType? textInputType;

  FontWeight? fontWeight;
  Color? color;
  double? size = -1;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  TextStyle modifyStyle(TextStyle textStyle) {
    return textStyle.copyWith(
      color: widget.color ?? textStyle.color,
      fontWeight: widget.fontWeight ?? textStyle.fontWeight,
      fontSize: widget.size != -1 ? widget.size : textStyle.fontSize,
    );
  }

  TextStyle getStyle(ThemeControllerState state) {
    if (widget.typeStyle is SubTitleText) {
      return modifyStyle(state.subTitleText!);
    } else if (widget.typeStyle is SubTitleButton) {
      return modifyStyle(state.subTitleButton!);
    } else if (widget.typeStyle is TitleButton) {
      return modifyStyle(state.titleButton!);
    } else if (widget.typeStyle is RadioButton) {
      return modifyStyle(state.radioButton!);
    } else if (widget.typeStyle is SmallText) {
      return modifyStyle(state.smallText!);
    } else if (widget.typeStyle is TitleText) {
      return modifyStyle(state.titleText!);
    }
    return modifyStyle(state.smallText!);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.textEditingController != null) {
      widget.textEditingController!.selection = TextSelection.fromPosition(
          TextPosition(offset: widget.textEditingController!.text.length));
    }
    return BlocBuilder<TextFieldControllerCubit, TextDirection>(
        builder: (context, stateTextDirection) {
      return BlocBuilder<ThemeControllerCubit, ThemeControllerState>(
          builder: (context, state) {
        return TextField(
          textDirection: stateTextDirection,
          controller: widget.textEditingController,
          onChanged: (str){
            widget.onchange(str);
            BlocProvider.of<TextFieldControllerCubit>(context).changeDirection(str);
          },
          keyboardType: widget.textInputType,
          cursorColor: kPrimaryColor,
          decoration: InputDecoration(
            hintText: widget.hintText,
            labelStyle: getStyle(state),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(width: 1.5),
            ),
          ),
        );
      });
    });
  }
}
