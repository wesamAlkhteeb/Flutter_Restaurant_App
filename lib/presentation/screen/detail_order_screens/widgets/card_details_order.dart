import 'package:flutter/material.dart';
import 'package:rest_app/bussiness_logic/theme_controller_cubit.dart';
import 'package:rest_app/constant/size_config.dart';
import 'package:rest_app/constant/themes.dart';
import 'package:rest_app/data/models/meal_order_model.dart';
import 'package:rest_app/presentation/widget/custom_text.dart';

class CardDetailsOrder extends StatelessWidget {
  CardDetailsOrder({Key? key, required this.mealOrderModel}) : super(key: key);

  MealOrderModel mealOrderModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.getPercentWidth(percent: .9),
      height: SizeConfig.getPercentHeight(percent: .18),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(45),
          bottomLeft: Radius.circular(45),
        ),
        color: kPrimaryColor,
        boxShadow: [
          BoxShadow(color: Colors.black38, spreadRadius: 1, blurRadius: 5),
        ],
      ),
      margin: EdgeInsets.only(
        bottom: SizeConfig.getPercentHeight(percent: .02),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(45),
              bottomLeft: Radius.circular(45),
            ),
            child: Image.network(
              mealOrderModel.image,
              height: SizeConfig.getPercentHeight(percent: .18),
              width: SizeConfig.getPercentWidth(percent: .3),
              fit: BoxFit.cover,
              loadingBuilder: (ctx, widget, isLoading) {

                if (isLoading == null) {
                  return widget;
                }
                return SizedBox(
                  height: SizeConfig.getPercentHeight(percent: .18),
                  width: SizeConfig.getPercentWidth(percent: .3),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: kWhiteColor,
                    ),
                  ),
                );
              },
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: SizeConfig.getPercentWidth(percent: .03),
                  ),
                  CustomText(text: "Name : ", typeStyle: TitleText()),
                  CustomText(
                    text: mealOrderModel.name,
                    typeStyle: SubTitleText(),
                    size: SizeConfig.getPercentWidth(percent: .06),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: SizeConfig.getPercentWidth(percent: .03),
                  ),
                  CustomText(text: "Pieces : ", typeStyle: TitleText()),
                  CustomText(
                    text: mealOrderModel.pieces,
                    typeStyle: SubTitleText(),
                    size: SizeConfig.getPercentWidth(percent: .06),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/*
GestureDetector(
      onTap: (){},
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Container(
              //
              //   child: Image.asset('assets/images/9987-12.jpg',fit: BoxFit.fill,),
              //   height: 170,
              //   width: MediaQuery.of(context).size.width * 0.4,
              // ),
              Container(

                height: 170,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Name'),
                    Text('amount'),

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
 */
