import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rest_app/bussiness_logic/star_controller_cubit.dart';
import 'package:rest_app/bussiness_logic/theme_controller_cubit.dart';
import 'package:rest_app/constant/size_config.dart';
import 'package:rest_app/constant/themes.dart';
import 'package:rest_app/presentation/widget/custom_text.dart';
import 'package:rest_app/services/storage_services.dart';

class StarWidget extends StatelessWidget {
  StarWidget(
      {Key? key,
      required this.height,
      required this.width,
      required this.onAction,
      this.idMeal,
      this.idRestaurant})
      : super(key: key);

  Function() onAction;

  double width, height;

  String? idMeal, idRestaurant;

  evaluateMeal(BuildContext context, double star) async {
    await BlocProvider.of<StarControllerCubit>(context)
        .addEvaluationMeal(
      idUser: StorageServices.getInstance().loadData(key: TokenKeyStorage())!,
      idMeal: idMeal!,
      starUser: star,
    )
        .then((value) {
      onAction();
    });
  }

  evaluateRestaurant(BuildContext context, double star) async {
    await BlocProvider.of<StarControllerCubit>(context)
        .addEvaluationRestaurant(
      idUser: StorageServices.getInstance().loadData(key: TokenKeyStorage())!,
      idRestaurant: idRestaurant!,
      starUser: star,
    )
        .then((value) {
      onAction();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.getPercentWidth(percent: .9),
      // color: Colors.red,
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.getPercentWidth(percent: .02),
        vertical: SizeConfig.getPercentHeight(percent: .01),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(3, 3),
            blurRadius: 10,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.getPercentWidth(percent: .01),
        ),
        child: Column(
          children: [
            CustomText(
              text: "We need your evaluation :",
              typeStyle: TitleText(),
              size: SizeConfig.getPercentWidth(percent: .06),
            ),
            SizedBox(
              height: SizeConfig.getPercentHeight(percent: .01),
            ),
            BlocBuilder<StarControllerCubit, StarControllerState>(
              builder: (context, state) {
                if (state is StarControllerDone) {
                  return CustomText(
                      text: "Thank you for your evaluation",
                      size: SizeConfig.getPercentWidth(percent: .05),
                      typeStyle: TitleText());
                } else {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        child: Icon(
                          Icons.star,
                          size: width * 0.18,
                          color: state.star >= 1 ? kPrimaryColor : Colors.grey,
                        ),
                        onTap: () async {
                          BlocProvider.of<StarControllerCubit>(context)
                              .changeStar(1);
                          if (idMeal != null) {
                            evaluateMeal(context, 1);
                          } else {
                            evaluateRestaurant(context, 1);
                          }
                        },
                      ),
                      GestureDetector(
                        child: Icon(
                          Icons.star,
                          size: width * 0.18,
                          color: state.star >= 2 ? kPrimaryColor : Colors.grey,
                        ),
                        onTap: () {
                          BlocProvider.of<StarControllerCubit>(context)
                              .changeStar(2);
                          if (idMeal != null) {
                            evaluateMeal(context, 2);
                          } else {
                            evaluateRestaurant(context, 2);
                          }
                        },
                      ),
                      GestureDetector(
                        child: Icon(
                          Icons.star,
                          size: width * 0.18,
                          color: state.star >= 3 ? kPrimaryColor : Colors.grey,
                        ),
                        onTap: () {
                          BlocProvider.of<StarControllerCubit>(context)
                              .changeStar(3);
                          if (idMeal != null) {
                            evaluateMeal(context, 3);
                          } else {
                            evaluateRestaurant(context, 3);
                          }
                        },
                      ),
                      GestureDetector(
                        child: Icon(
                          Icons.star,
                          size: width * 0.18,
                          color: state.star >= 4 ? kPrimaryColor : Colors.grey,
                        ),
                        onTap: () {
                          BlocProvider.of<StarControllerCubit>(context)
                              .changeStar(4);
                          if (idMeal != null) {
                            evaluateMeal(context, 4);
                          } else {
                            evaluateRestaurant(context, 4);
                          }
                        },
                      ),
                      GestureDetector(
                        child: Icon(
                          Icons.star,
                          size: width * 0.18,
                          color: state.star >= 5 ? kPrimaryColor : Colors.grey,
                        ),
                        onTap: () {
                          BlocProvider.of<StarControllerCubit>(context)
                              .changeStar(5);
                          if (idMeal != null) {
                            evaluateMeal(context, 5);
                          } else {
                            evaluateRestaurant(context, 5);
                          }
                        },
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
