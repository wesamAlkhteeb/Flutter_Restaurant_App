import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rest_app/bussiness_logic/main_controller_cubit.dart';
import 'package:rest_app/bussiness_logic/meal_controller_cubit.dart';
import 'package:rest_app/bussiness_logic/restaurants_controller_cubit.dart';
import 'package:rest_app/constant/size_config.dart';
import 'package:rest_app/constant/themes.dart';
import 'package:rest_app/presentation/widget/custom_text_field_search.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.getPercentWidth(percent: 1),
      height: SizeConfig.getPercentHeight(percent: .1),
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.getPercentHeight(percent: .01),
        horizontal: SizeConfig.getPercentWidth(percent: .02),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: LayoutBuilder(builder: (context, constrain) {
              return Icon(
                Icons.menu_rounded,
                size: constrain.maxWidth,
              );
            }),
          ),
          SizedBox(
            width: SizeConfig.getPercentWidth(percent: .05),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: SizeConfig.getPercentHeight(percent: .01),
                horizontal: SizeConfig.getPercentWidth(percent: .04),
              ),
              decoration: BoxDecoration(
                border: Border.all(color: kPrimaryColor, width: 1.5),
                borderRadius: const BorderRadius.all(
                     Radius.circular(50),
                    ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextFieldSearch(
                      onChange: (str) {
                        BlocProvider.of<MealControllerCubit>(context).search =
                            str!;
                        BlocProvider.of<MealControllerCubit>(context)
                            .changeListFilter();
                        BlocProvider.of<RestaurantsControllerCubit>(context)
                            .search = str;
                        BlocProvider.of<RestaurantsControllerCubit>(context)
                            .changeListFilter();

                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/*

          Container(
            width: SizeConfig.getPercentWidth(percent: .2),
            height: double.infinity,
            decoration: const BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            child: LayoutBuilder(builder: (context, constrain) {
              return Icon(
                Icons.search,
                color: kWhiteColor,
                size: constrain.maxWidth * .5,
              );
            }),
          ),
 */