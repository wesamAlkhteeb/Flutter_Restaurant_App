import 'package:flutter/material.dart';
import 'package:rest_app/bussiness_logic/theme_controller_cubit.dart';
import 'package:rest_app/constant/size_config.dart';
import 'package:rest_app/constant/themes.dart';
import 'package:rest_app/data/models/meal_model.dart';
import 'package:rest_app/presentation/widget/custom_text.dart';

class CardMealWidget extends StatelessWidget {
  const CardMealWidget({Key? key, required this.press, required this.product})
      : super(key: key);

  final MealModel product;
  final VoidCallback press;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: product.image == ""
                    ? Image.asset(
                  "assets/images/default_meal.png",
                  fit: BoxFit.fill,
                )
                    : Image.network(
                  width: double.infinity,
                  product.image,
                  fit: BoxFit.fill,
                ),
              )
            ),
            SizedBox(height: SizeConfig.getPercentHeight(percent: .02)),
            Padding(
              padding: EdgeInsets.only(left: SizeConfig.getPercentWidth(percent: .02),right: SizeConfig.getPercentWidth(percent: .02),bottom: SizeConfig.getPercentHeight(percent: .01)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width:SizeConfig.getPercentWidth(percent: .4),
                    child: CustomText(
                      text: product.title,
                      typeStyle: SubTitleText(),
                      fontWeight: FontWeight.w700,
                      isLongText: true,
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width:SizeConfig.getPercentWidth(percent: .25),
                        child: CustomText(
                          text: "${product.price} SYP",
                          typeStyle: SubTitleText(),
                          size: SizeConfig.getPercentHeight(percent: .023),
                          isLongText: true,
                        ),
                      ),
                      const Spacer(),
                      CustomText(
                        text: product.rating.toStringAsFixed(1),
                        typeStyle: SubTitleText(),
                        size: SizeConfig.getPercentHeight(percent: .023),
                      ),
                      SizedBox(width: SizeConfig.getPercentWidth(percent: .02)),
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: SizeConfig.getPercentWidth(percent: .06),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
