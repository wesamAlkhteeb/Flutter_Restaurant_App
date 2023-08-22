import 'package:flutter/material.dart';
import 'package:rest_app/bussiness_logic/theme_controller_cubit.dart';
import 'package:rest_app/constant/size_config.dart';
import 'package:rest_app/constant/themes.dart';
import 'package:rest_app/data/models/resturant_model.dart';
import 'package:rest_app/presentation/widget/custom_text.dart';

class CardRestaurantWidget extends StatelessWidget {
  const CardRestaurantWidget(
      {Key? key, required this.restaurant, required this.press})
      : super(key: key);

  final RestaurantModel restaurant;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: SizeConfig.getPercentHeight(percent: .25),
          decoration: BoxDecoration(
            color: kGrayColor.withOpacity(0.5),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: SizeConfig.getPercentWidth(percent: .4),
                height: SizeConfig.getPercentHeight(percent: .25),
                child: (restaurant.image.isEmpty)?Image.asset("assets/images/default_user.jpg",fit: BoxFit.cover,):Image.network(
                  restaurant.image,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: SizeConfig.getPercentWidth(percent: .04)),
              SizedBox(
                height: SizeConfig.getPercentHeight(percent: .25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(
                      flex: 2,
                    ),
                    Row(
                      children: [
                        CustomText(
                          text: "Name : ",
                          typeStyle: SubTitleText(),
                          fontWeight: FontWeight.w700,
                        ),
                        CustomText(
                          text: restaurant.name,
                          typeStyle: SubTitleText(),
                          isLongText: true,
                          width: SizeConfig.getPercentWidth(percent: .3),
                        ),
                      ],
                    ),
                    const Spacer(
                      flex: 1,
                    ),
                    Row(
                      children: [
                        CustomText(
                          text: "Address : ",
                          typeStyle: SubTitleText(),
                          fontWeight: FontWeight.w700,
                        ),
                        CustomText(
                          text: restaurant.address,
                          typeStyle: SubTitleText(),
                          isLongText: true,
                          width: SizeConfig.getPercentWidth(percent: .26),
                        ),
                      ],
                    ),
                    const Spacer(
                      flex: 1,
                    ),
                    Row(
                      children: [
                        CustomText(
                          text: "${restaurant.rating}",
                          typeStyle: SubTitleText(),
                        ),
                        SizedBox(
                          width: SizeConfig.getPercentWidth(percent: .02),
                        ),
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                      ],
                    ),
                    const Spacer(
                      flex: 2,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
