import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rest_app/bussiness_logic/main_controller_cubit.dart';
import 'package:rest_app/bussiness_logic/meal_controller_cubit.dart';
import 'package:rest_app/bussiness_logic/restaurants_controller_cubit.dart';
import 'package:rest_app/bussiness_logic/theme_controller_cubit.dart';
import 'package:rest_app/constant/size_config.dart';
import 'package:rest_app/constant/strings.dart';
import 'package:rest_app/constant/themes.dart';
import 'package:rest_app/data/web_services/meal_web_services.dart';
import 'package:rest_app/presentation/screen/main_screens/profile_chief/profile_screen.dart';
import 'package:rest_app/presentation/screen/main_screens/profile_chief/widgets/card_meal_widget.dart';
import 'package:rest_app/presentation/widget/custom_appbar.dart';
import 'package:rest_app/presentation/widget/category.dart';
import 'package:rest_app/presentation/widget/custom_text.dart';
import 'package:rest_app/presentation/widget/card_restaurant_widget.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key, required this.user}) : super(key: key);
  bool user;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  initState() {
    BlocProvider.of<RestaurantsControllerCubit>(context).fetchAllRestaurant();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          height: SizeConfig.getPercentHeight(percent: .01),
        ),
        const CustomAppbar(),
        SizedBox(
          height: SizeConfig.getPercentHeight(percent: .02),
        ),
        SizedBox(
          height: SizeConfig.getPercentHeight(percent: .1),
          child: BlocBuilder<MainControllerCubit, MainControllerState>(
            builder: (context, state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CategoryList(
                    press: () {
                      BlocProvider.of<MainControllerCubit>(context)
                          .changeIndexCategory(categoryScreen: MealSection());
                    },
                    title: 'All Meal',
                    select: state is MealSection,
                  ),
                  CategoryList(
                    press: () {
                      BlocProvider.of<MainControllerCubit>(context)
                          .changeIndexCategory(
                              categoryScreen: RestaurantSection());
                    },
                    title: 'Chief',
                    select: state is RestaurantSection,
                  ),
                ],
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<MainControllerCubit, MainControllerState>(
            builder: (context, state) {
              return CustomText(
                text: state is MealSection
                    ? 'popular food'
                    : state is RestaurantSection
                        ? 'Restaurants'
                        : 'Meal More Rating',
                typeStyle: SubTitleText(),
                fontWeight: FontWeight.w900,
                size: SizeConfig.getPercentWidth(percent: .08),
              );
            },
          ),
        ),
        SizedBox(
          height: SizeConfig.getPercentHeight(percent: .02),
        ),
        BlocBuilder<MainControllerCubit, MainControllerState>(
          builder: (ctx, state) {
            if (state is MealSection) {
              return BlocBuilder<MealControllerCubit, MealState>(
                  builder: (contextMealCubit, stateMeal) {
                if (stateMeal is DoneStateMeal) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.getPercentWidth(percent: .04),
                    ),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: stateMeal.mealsFilter.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: .75,
                        mainAxisSpacing:
                            SizeConfig.getPercentHeight(percent: .016),
                        crossAxisSpacing:
                            SizeConfig.getPercentWidth(percent: .03),
                      ),
                      itemBuilder: (context, index) => CardMealWidget(
                        press: () {
                          Navigator.of(context).pushNamed(
                            detailMealScreen,
                            arguments: {
                              "myMeal": false,
                              "meal": stateMeal.mealsFilter[index],
                              "idRestaurant": "",
                            },
                          );
                        },
                        product: stateMeal.mealsFilter[index],
                      ),
                    ),
                  );
                } else if (stateMeal is LoadingStateMeal) {
                  return const Center(
                    child: CircularProgressIndicator(color: kPrimaryColor),
                  );
                } else {
                  return Center(
                    child: CustomText(
                        text: "Can't Loading Data", typeStyle: TitleText()),
                  );
                }
              });
            } else if (state is RestaurantSection) {
              return BlocBuilder<RestaurantsControllerCubit,
                  RestaurantsControllerState>(builder: (context, state) {
                if (state is RestaurantDoneState) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount:
                        BlocProvider.of<RestaurantsControllerCubit>(context)
                            .allRestaurantList()
                            .length,
                    itemBuilder: (context, index) {
                      return CardRestaurantWidget(
                        restaurant:
                            BlocProvider.of<RestaurantsControllerCubit>(context)
                                .allRestaurantList()[index],
                        press: () {
                          Navigator.of(context).pushNamed(
                            profileScreen,
                            arguments: [
                              !widget.user,
                              state.allRestaurant[index].id,
                              RestaurantNavigator()
                            ],
                          );
                        },
                      );
                    },
                  );
                } else if (state is RestaurantLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(color: kPrimaryColor),
                  );
                } else {
                  return Center(
                    child: CustomText(
                        text: "Error Loading ", typeStyle: TitleText()),
                  );
                }
              });
            }
            return const CircularProgressIndicator(color: kPrimaryColor,);
          },
        )
      ],
    );
  }
}
