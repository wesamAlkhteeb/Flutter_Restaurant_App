import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rest_app/bussiness_logic/cart_controller_cubit.dart';
import 'package:rest_app/bussiness_logic/theme_controller_cubit.dart';
import 'package:rest_app/constant/size_config.dart';
import 'package:rest_app/constant/themes.dart';
import 'package:rest_app/data/models/meal_model.dart';
import 'package:rest_app/presentation/widget/custom_text.dart';

class ChooseMealCountWidget extends StatelessWidget {
  ChooseMealCountWidget(
      {Key? key, required this.idRestaurant, required this.mealModel})
      : super(key: key);
  String idRestaurant;
  MealModel mealModel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: SizeConfig.getPercentWidth(percent: .6),
        height: SizeConfig.getPercentHeight(percent: .12),
        decoration: BoxDecoration(
          color: Colors.grey[500],
          borderRadius: BorderRadius.circular(45),
        ),
        child: BlocProvider.of<CartControllerCubit>(context)
                .checkChoose(idRestaurant: idRestaurant)
            ? Center(
                child: GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.getPercentWidth(percent: .05)),
                    child: CustomText(
                      text: "Close Order to choose from other restaurant",
                      typeStyle: SubTitleText(),
                      size: SizeConfig.getPercentWidth(percent: .04),
                      fontWeight: FontWeight.w700,
                      color: kWhiteColor,
                    ),
                  ),
                  onTap: () {},
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    child: Container(
                      width: SizeConfig.getPercentWidth(percent: .12),
                      height: SizeConfig.getPercentWidth(percent: .12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(45),
                        color: kWhiteColor,
                      ),
                      child: Icon(
                        Icons.remove,
                        color: Colors.grey[500],
                        size: SizeConfig.getPercentHeight(percent: .05),
                      ),
                    ),
                    onTap: () {
                      BlocProvider.of<CartControllerCubit>(context)
                          .minusMealToOrder(
                        id: mealModel.id,
                        nameMeal: mealModel.title,
                        priceOneMeal: mealModel.price,
                      );
                    },
                  ),
                  BlocBuilder<CartControllerCubit, CartControllerState>(
                    builder: (context, state) {
                      return CustomText(
                        text: state is CartControllerDone ? BlocProvider.of<CartControllerCubit>(context)
                            .getNumberForMeal(id: mealModel.id):"0",
                        typeStyle: TitleText(),
                        color: kWhiteColor,
                      );
                    },
                  ),
                  GestureDetector(
                    child: Container(
                      width: SizeConfig.getPercentWidth(percent: .12),
                      height: SizeConfig.getPercentWidth(percent: .12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(45),
                        color: kWhiteColor,
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.grey[500],
                        size: SizeConfig.getPercentHeight(percent: .05),
                      ),
                    ),
                    onTap: () {
                      BlocProvider.of<CartControllerCubit>(context)
                          .addMealToOrder(
                        id: mealModel.id,
                        nameMeal: mealModel.title,
                        priceOneMeal: mealModel.price,
                        imageUri: mealModel.image
                      );
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
