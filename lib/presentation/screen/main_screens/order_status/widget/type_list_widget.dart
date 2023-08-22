import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rest_app/bussiness_logic/order_controller_cubit.dart';
import 'package:rest_app/bussiness_logic/theme_controller_cubit.dart';
import 'package:rest_app/constant/size_config.dart';
import 'package:rest_app/constant/themes.dart';
import 'package:rest_app/presentation/widget/custom_text.dart';

class TypeListOrderWidget extends StatelessWidget {
  TypeListOrderWidget({Key? key, required this.onTap , required this.text , required this.isSelected}) : super(key: key);

  String text;
  Function() onTap;
  bool Function() isSelected ;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: BlocBuilder<OrderControllerCubit , OrderControllerState>(
        builder: (context , state) {
          return Container(
            width: SizeConfig.getPercentWidth(percent: .4),
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.getPercentWidth(percent: .02),
              vertical: SizeConfig.getPercentHeight(percent: .02),
            ),
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: isSelected() ? Colors.black: Colors.grey,
                width: isSelected() ? 1.5 : 1,
              ),
            ),
            child: Center(
              child: CustomText(
                text: text,
                typeStyle: SubTitleText(),
                color: kWhiteColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          );
        }
      ),
    );
  }
}
