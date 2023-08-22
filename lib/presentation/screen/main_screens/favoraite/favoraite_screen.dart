import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rest_app/bussiness_logic/favorite_controller_cubit.dart';
import 'package:rest_app/bussiness_logic/theme_controller_cubit.dart';
import 'package:rest_app/constant/strings.dart';
import 'package:rest_app/constant/themes.dart';
import 'package:rest_app/presentation/screen/main_screens/profile_chief/profile_screen.dart';
import 'package:rest_app/presentation/widget/card_restaurant_widget.dart';
import 'package:rest_app/presentation/widget/custom_text.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  initState() {
    BlocProvider.of<FavoriteControllerCubit>(context).getRestaurantFavorite();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<FavoriteControllerCubit, FavoriteControllerState>(
            builder: (context, state) {
          if (state is FavoriteControllerLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: kPrimaryColor,
              ),
            );
          } else if (state is FavoriteControllerError) {
            return Center(
              child:
                  CustomText(text: "Error In Loading", typeStyle: TitleText()),
            );
          } else {
            return ListView(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Restaurants',
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: BlocProvider.of<FavoriteControllerCubit>(context)
                      .restaurantFavorite
                      .length,
                  itemBuilder: (context, index) {
                    return CardRestaurantWidget(
                        restaurant:
                            BlocProvider.of<FavoriteControllerCubit>(context)
                                .restaurantFavorite[index],
                        press: () {
                          Navigator.of(context).pushReplacementNamed(
                            profileScreen,
                            arguments: [
                              false,
                              BlocProvider.of<FavoriteControllerCubit>(context)
                                  .restaurantFavorite[index]
                                  .id,
                              FavoriteNavigator(),
                            ],
                          );
                        });
                  },
                )
              ],
            );
          }
        }),
      ),
    );
  }
}
