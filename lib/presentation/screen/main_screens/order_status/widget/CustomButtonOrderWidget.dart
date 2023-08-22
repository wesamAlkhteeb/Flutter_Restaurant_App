import 'package:flutter/material.dart';
import 'package:rest_app/bussiness_logic/theme_controller_cubit.dart';
import 'package:rest_app/constant/themes.dart';
import 'package:rest_app/presentation/widget/custom_text.dart';

class CustomButtonOrderWidget extends StatelessWidget {
  CustomButtonOrderWidget({
    Key? key,
    required this.text,
    required this.color,
    required this.onTap,
    required this.width,
    required this.height,
    required this.isHaveBorder,

  }) : super(key: key);

  Function() onTap;
  Color color;

  String text;
  double width, height;
  bool isHaveBorder;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          border: isHaveBorder ? Border.all(
            color: Colors.black54,
            width: 1.5
          ):null
        ),
        child: Center(
          child: CustomText(
            text: text,
            typeStyle: SubTitleText(),
          ),
        ),
      ),
    );
  }
}
