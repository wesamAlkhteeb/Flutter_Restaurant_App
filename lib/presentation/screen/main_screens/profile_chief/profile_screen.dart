import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rest_app/bussiness_logic/authentication_cubit.dart';
import 'package:rest_app/bussiness_logic/conversation_controller_cubit.dart';
import 'package:rest_app/bussiness_logic/favorite_controller_cubit.dart';
import 'package:rest_app/bussiness_logic/meal_controller_cubit.dart';
import 'package:rest_app/bussiness_logic/theme_controller_cubit.dart';
import 'package:rest_app/constant/size_config.dart';
import 'package:rest_app/constant/strings.dart';
import 'package:rest_app/constant/themes.dart';
import 'package:rest_app/data/web_services/authentication/authontication_web_services.dart';
import 'package:rest_app/data/web_services/meal_web_services.dart';
import 'package:rest_app/presentation/screen/add_and_update_meal/add_update_meal.dart';
import 'package:rest_app/presentation/screen/main_screens/profile_chief/widgets/card_meal_widget.dart';
import 'package:rest_app/presentation/widget/CustomDialog.dart';
import 'package:rest_app/presentation/widget/custom_text.dart';
import 'package:rest_app/presentation/widget/star_widget.dart';
import 'package:rest_app/services/storage_services.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen(
      {Key? key,
      required this.isChief,
      this.idRestaurant,
      this.stateProfileNavigator})
      : super(key: key) {
    idRestaurant = idRestaurant ??
        StorageServices.getInstance().loadData(key: TokenKeyStorage());

  }

  bool isChief;
  String? idRestaurant;
  StateProfileNavigator? stateProfileNavigator;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  initState() {
    if (widget.idRestaurant != null) {
      BlocProvider.of<FavoriteControllerCubit>(context)
          .getStateFavorite(widget.idRestaurant!);
      BlocProvider.of<MealControllerCubit>(context).getAllMeal(
        stateFetch:
            AllMealForRestaurantUserFetch(idRestaurant: widget.idRestaurant),
      );
    } else {
      BlocProvider.of<MealControllerCubit>(context)
          .getAllMeal(stateFetch: AllMealForRestaurantFetch());
    }
    if (!BlocProvider.of<AuthenticationCubit>(context).requestProfile) {
      BlocProvider.of<AuthenticationCubit>(context)
          .getDataProfile(idRestaurant: widget.idRestaurant);
    }
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).size.height / 3 -
        MediaQuery.of(context).size.height / 9;
    return WillPopScope(
      onWillPop: () async {
        if (widget.stateProfileNavigator == null) {
          return false;
        }
        Navigator.of(context).pushReplacementNamed(
          mainScreen,
          arguments: widget.stateProfileNavigator is FavoriteNavigator ? 1 : 0,
        );
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
              builder: (context, state) {
            if (state is AuthenticationErrorState) {
              return Center(
                child: CustomText(
                  text: "error",
                  typeStyle: TitleText(),
                ),
              );
            } else if (state is AuthenticationLoadingState) {
              return const Center(
                child: CircularProgressIndicator(
                  color: kPrimaryColor,
                ),
              );
            } else {
              return ListView(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (widget.isChief) {
                            if (widget.idRestaurant ==
                                StorageServices.getInstance().loadData(
                                  key: TokenKeyStorage(),
                                )) {
                              CustomDialog.dialogImage(
                                BackImageUpdateType(),
                                context,
                              );
                            }
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            bottom: SizeConfig.getPercentHeight(percent: .1),
                          ),
                          height: SizeConfig.getPercentHeight(percent: .33),
                          width: double.infinity,
                          child: state.account!.backImage == "" ||
                                  state.account!.backImage == null
                              ? Image.asset(
                                  'assets/images/default_restaurant.jpg',
                                  width: double.infinity,
                                  height:
                                      SizeConfig.getPercentHeight(percent: .33),
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  state.account!.backImage!,
                                  width: double.infinity,
                                  height:
                                      SizeConfig.getPercentHeight(percent: .33),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      Positioned(
                        top: top,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            state.account!.frontImage == null ||
                                    state.account!.frontImage! == ""
                                ? CircleAvatar(
                                    radius:
                                        MediaQuery.of(context).size.width / 5,
                                    backgroundColor: Colors.grey.shade800,
                                    backgroundImage: const AssetImage(
                                      'assets/images/default_user.jpg',
                                    ))
                                : CircleAvatar(
                                    radius:
                                        MediaQuery.of(context).size.width / 5,
                                    backgroundColor: Colors.grey.shade800,
                                    backgroundImage: NetworkImage(
                                      state.account!.frontImage!,
                                    ),
                                  ),
                            if (widget.isChief &&
                                widget.idRestaurant ==
                                    StorageServices.getInstance()
                                        .loadData(key: TokenKeyStorage()))
                              GestureDetector(
                                onTap: () {
                                  if (widget.idRestaurant ==
                                      StorageServices.getInstance()
                                          .loadData(key: TokenKeyStorage())) {
                                    CustomDialog.dialogImage(
                                      FrontImageUpdateType(),
                                      context,
                                    );
                                  }
                                },
                                child: Container(
                                  width:
                                      SizeConfig.getPercentWidth(percent: .12),
                                  height:
                                      SizeConfig.getPercentWidth(percent: .12),
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(45)),
                                  child: LayoutBuilder(
                                    builder: (context, constrain) {
                                      return Icon(
                                        Icons.edit,
                                        size: constrain.maxWidth * .6,
                                        color: Colors.white70,
                                      );
                                    },
                                  ),
                                ),
                              ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.getPercentHeight(percent: .04),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(
                        flex: 7,
                      ),
                      const Icon(
                        Icons.person,
                        color: kPrimaryColor,
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                      CustomText(
                        text: state.account!.username,
                        typeStyle: TitleText(),
                      ),
                      const Spacer(
                        flex: 9,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.getPercentHeight(percent: .02),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(
                        flex: 7,
                      ),
                      const Icon(Icons.home, color: kPrimaryColor),
                      const Spacer(
                        flex: 1,
                      ),
                      CustomText(
                        text: state.account!.address! == ""
                            ? "not add"
                            : state.account!.address!,
                        typeStyle: TitleText(),
                      ),
                      const Spacer(
                        flex: 9,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.getPercentHeight(percent: .04),
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      CustomText(
                          text: "${state.account!.star!}",
                          typeStyle: SubTitleText()),
                      SizedBox(
                        width: SizeConfig.getPercentWidth(percent: .02),
                      ),
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          if (widget.isChief &&
                              widget.idRestaurant ==
                                  StorageServices.getInstance()
                                      .loadData(key: TokenKeyStorage())) {
                            Navigator.of(context).pushNamed(
                              addMealScreen,
                              arguments: {
                                "typeScreen": AddMealOperation(),
                              },
                            );
                          } else if (!widget.isChief) {
                            BlocProvider.of<FavoriteControllerCubit>(context)
                                .saveRestaurantToFavorite(widget.idRestaurant!);
                          }
                        },
                        child: BlocBuilder<FavoriteControllerCubit,
                            FavoriteControllerState>(
                          builder: (context, state) {
                            return Icon(
                              widget.isChief
                                  ? Icons.add
                                  : BlocProvider.of<FavoriteControllerCubit>(
                                              context)
                                          .isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                              color: BlocProvider.of<FavoriteControllerCubit>(
                                          context)
                                      .isFavorite
                                  ? kPrimaryColor
                                  : Colors.black,
                            );
                          },
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        child:
                            Icon(widget.isChief ? Icons.edit : Icons.message),
                        onTap: () {
                          if (widget.isChief &&
                              widget.idRestaurant ==
                                  StorageServices.getInstance()
                                      .loadData(key: TokenKeyStorage())) {
                            CustomDialog.dialogEditProfile(
                              state.account!.username,
                              state.account!.address!,
                              context,
                            );
                          } else if (!widget.isChief) {
                            BlocProvider.of<ConversationControllerCubit>(
                                    context)
                                .addConversation(
                              idFriend: widget.idRestaurant!,
                            )
                                .then(
                              (value) {
                                Navigator.of(context)
                                    .pushNamed(conversationScreen);
                              },
                            );
                          }
                        },
                      ),
                      const Spacer(),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.getPercentHeight(percent: .04),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.getPercentWidth(percent: .03),
                      vertical: SizeConfig.getPercentHeight(percent: .01),
                    ),
                    child: CustomText(
                      text: "My Meals",
                      typeStyle: TitleText(),
                      size: 22,
                    ),
                  ),
                  BlocBuilder<MealControllerCubit, MealState>(
                      builder: (context, stateMeal) {
                    if (stateMeal is DoneStateMeal) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemCount: stateMeal.mealsForRestaurant.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: .75,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10),
                          itemBuilder: (context, index) => CardMealWidget(
                              press: () {
                                Navigator.of(context).pushNamed(
                                  detailMealScreen,
                                  arguments: {
                                    "myMeal": widget.idRestaurant == null
                                        ? true
                                        : widget.idRestaurant ==
                                            StorageServices.getInstance()
                                                .loadData(
                                                    key: TokenKeyStorage()),
                                    "meal": stateMeal.mealsForRestaurant[index],
                                    "idRestaurant": widget.idRestaurant,
                                  },
                                );
                              },
                              product: stateMeal.mealsForRestaurant[index]),
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
                  }),
                  SizedBox(
                    height: SizeConfig.getPercentHeight(percent: .04),
                  ),
                  if (!widget.isChief)
                    StarWidget(
                      height: SizeConfig.getPercentHeight(percent: .15),
                      width: SizeConfig.getPercentWidth(percent: .7),
                      idRestaurant: widget.idRestaurant,
                      onAction: () {
                        Navigator.of(context).pushReplacementNamed(mainScreen);
                      },
                    ),
                ],
              );
            }
          }),
        ),
      ),
    );
  }
}

abstract class StateProfileNavigator {}

class FavoriteNavigator extends StateProfileNavigator {}

class RestaurantNavigator extends StateProfileNavigator {}
