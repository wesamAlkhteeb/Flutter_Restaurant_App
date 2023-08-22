import 'package:flutter/material.dart';
import 'package:rest_app/constant/size_config.dart';
import 'package:rest_app/constant/themes.dart';
import 'package:rest_app/presentation/widget/custom_text.dart';

import '../../bussiness_logic/theme_controller_cubit.dart';

class CategoryList extends StatelessWidget {
  const CategoryList(
      {Key? key,
      required this.title,
      required this.press,
      required this.select})
      : super(key: key);
  final String title;
  final VoidCallback press;
  final bool select;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Chip(
        side: select
            ? const BorderSide(color: Colors.black38, width: 1.5)
            : BorderSide.none,
        backgroundColor: kPrimaryColor,
        label: SizedBox(
          width:SizeConfig.getPercentWidth(percent: .38),
          height: SizeConfig.getPercentHeight(percent: .07),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: CustomText(
                text: title,
                typeStyle: SmallText(),
                fontWeight: FontWeight.w700,
                size: SizeConfig.getPercentWidth(percent: .048),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
