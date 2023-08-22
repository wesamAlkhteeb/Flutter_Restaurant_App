import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rest_app/bussiness_logic/cart_controller_cubit.dart';
import 'package:rest_app/bussiness_logic/theme_controller_cubit.dart';
import 'package:rest_app/constant/size_config.dart';
import 'package:rest_app/constant/themes.dart';
import 'package:rest_app/presentation/widget/custom_text.dart';

class CartCard extends StatelessWidget {
  CartCard({
    Key? key,
    required this.index,
  }) : super(key: key);

  int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: SizeConfig.getPercentWidth(percent: 1),
      height: SizeConfig.getPercentHeight(percent: .12),
      margin: EdgeInsets.symmetric(
        vertical: SizeConfig.getPercentHeight(percent: .01),
        horizontal: SizeConfig.getPercentWidth(percent: .01),
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
        color: Colors.grey[400],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
            child: Image.network(
              cartModel.allOrder[index].imageUri,
              fit: BoxFit.cover,
              width: SizeConfig.getPercentWidth(percent: .2),
              height: double.infinity,
            ),
          ),
          SizedBox(
            width: SizeConfig.getPercentWidth(percent: .03),
          ),
          SizedBox(
              height: double.infinity,
              width: SizeConfig.getPercentWidth(percent: .3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(flex: 1,),
                  CustomText(
                    text: cartModel.allOrder[index].nameMeal,
                    typeStyle: SubTitleText(),
                    color: kWhiteColor,
                    width: double.infinity,
                    isLongText: true,
                    fontWeight: FontWeight.w700,
                  ),
                  const Spacer(flex: 2,),
                  CustomText(
                    text: "${cartModel.allOrder[index].priceOneMeal} SYP",
                    typeStyle: SubTitleText(),
                    color: kWhiteColor,
                    width: double.infinity,
                    isLongText: true,
                    fontWeight: FontWeight.w700,
                  ),
                  const Spacer(flex: 1,),
                ],
              )

              // RichText(
              //   text: TextSpan(
              //     style: const TextStyle(
              //         overflow: TextOverflow.ellipsis
              //     ),
              //     children: [
              //       TextSpan(
              //         text: "${cartModel.allOrder[index].nameMeal} \n\n",
              //         style: TextStyle(
              //           fontWeight: FontWeight.w700,
              //           fontSize: SizeConfig.getPercentWidth(percent: .06),
              //         ),
              //       ),
              //       TextSpan(
              //         text: "${cartModel.allOrder[index].priceOneMeal} SYP",
              //         style: TextStyle(
              //           fontSize: SizeConfig.getPercentWidth(percent: .05),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              ),
          Spacer(),
          GestureDetector(
            child: Container(
              width: SizeConfig.getPercentWidth(percent: .12),
              height: SizeConfig.getPercentWidth(percent: .12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(45),
                color: kPrimaryColor,
              ),
              child: Icon(
                Icons.remove,
                color: kWhiteColor,
                size: SizeConfig.getPercentHeight(percent: .05),
              ),
            ),
            onTap: () {
              BlocProvider.of<CartControllerCubit>(context)
                  .addFromCart(index: index);
            },
          ),
          SizedBox(
            width: SizeConfig.getPercentWidth(percent: .03),
          ),
          CustomText(
            text: cartModel.allOrder[index].numberOfMeal,
            typeStyle: TitleText(),
            fontWeight: FontWeight.w700,
            color: kWhiteColor,
          ),
          SizedBox(
            width: SizeConfig.getPercentWidth(percent: .03),
          ),
          GestureDetector(
            child: Container(
              width: SizeConfig.getPercentWidth(percent: .12),
              height: SizeConfig.getPercentWidth(percent: .12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(45),
                color: kPrimaryColor,
              ),
              child: Icon(
                Icons.add,
                color: kWhiteColor,
                size: SizeConfig.getPercentHeight(percent: .05),
              ),
            ),
            onTap: () {
              BlocProvider.of<CartControllerCubit>(context)
                  .minusFromCart(index: index);
            },
          ),
          SizedBox(
            width: SizeConfig.getPercentWidth(percent: .02),
          ),
        ],
      ),
    );
  }
}
