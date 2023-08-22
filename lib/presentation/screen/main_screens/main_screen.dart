import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rest_app/bussiness_logic/authentication_cubit.dart';
import 'package:rest_app/bussiness_logic/meal_controller_cubit.dart';
import 'package:rest_app/bussiness_logic/theme_controller_cubit.dart';
import 'package:rest_app/constant/size_config.dart';
import 'package:rest_app/constant/strings.dart';
import 'package:rest_app/constant/themes.dart';
import 'package:rest_app/data/models/account_model.dart';
import 'package:rest_app/data/web_services/meal_web_services.dart';
import 'package:rest_app/presentation/screen/main_screens/favoraite/favoraite_screen.dart';
import 'package:rest_app/presentation/screen/main_screens/home/home_screen.dart';
import 'package:rest_app/presentation/screen/main_screens/order_status/order_status_screen.dart';
import 'package:rest_app/presentation/screen/main_screens/profile_chief/profile_screen.dart';
import 'package:rest_app/presentation/widget/CustomDialog.dart';
import 'package:rest_app/presentation/widget/custom_text.dart';
import 'package:rest_app/services/CustomNotification.dart';
import 'package:rest_app/services/firebase_messageing_services.dart';
import 'package:rest_app/services/storage_services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class MainScreen extends StatefulWidget {
  bool? isChief;

  MainScreen({Key? key, this.currentIndex = 0}) : super(key: key) {
    isChief = StorageServices.getInstance().loadData(key: TypeKeyStorage()) ==
        ChiefAccount().type;
  }

  int? currentIndex = 0;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  initState() {
    tz.initializeTimeZones();
    notification();
    isFoundAccount();
    BlocProvider.of<MealControllerCubit>(context)
        .getAllMeal(stateFetch: AllMealFetch());
    if (!BlocProvider
        .of<AuthenticationCubit>(context)
        .requestProfile) {
      BlocProvider.of<AuthenticationCubit>(context).getDataProfile();
    }
  }

  Future<void> notification() async {
  // FirebaseMessagingServices.instance().sendNotification(title: "sos" ,body:  "asd");
  }

  isFoundAccount() async {
    await BlocProvider.of<AuthenticationCubit>(context).isFoundAccount();
    if (StorageServices.getInstance().loadData(key: TokenKeyStorage()) == "") {
      Navigator.of(context).pushReplacementNamed(loginScreen);
    }
  }

  final screensChief = [
    HomeScreen(user: false),
    ProfileScreen(
        isChief: true,
        idRestaurant:
        StorageServices.getInstance().loadData(key: TokenKeyStorage())),
    OrderStatusScreen()
  ];
  final screensUsers = [
    HomeScreen(user: true),
    const FavoriteScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    SizeConfig(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height);
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            BlocBuilder<AuthenticationCubit, AuthenticationState>(
                builder: (context, state) {
                  return UserAccountsDrawerHeader(
                    accountName: Row(
                      children: [
                        CustomText(
                          text: "Name : ",
                          typeStyle: TitleText(),
                          size: 20,
                        ),
                        CustomText(
                          text: (state is AuthenticationLoadingState ||
                              state is AuthenticationErrorState)
                              ? StorageServices.getInstance()
                              .loadData(key: UsernameKeyStorage()) ??
                              "Can't Loading"
                              : state.account!.username,
                          typeStyle: SubTitleText(),
                          isLongText: true,
                          width: SizeConfig.getPercentWidth(percent: .58),
                        ),
                      ],
                    ),
                    accountEmail: Row(
                      children: [
                        CustomText(
                          text: "Email : ",
                          typeStyle: TitleText(),
                          size: 20,
                        ),
                        CustomText(
                          text: (state is AuthenticationLoadingState ||
                              state is AuthenticationErrorState)
                              ? StorageServices.getInstance()
                              .loadData(key: EmailKeyStorage()) ??
                              "Can't Loading"
                              : state.account!.email,
                          typeStyle: SubTitleText(),
                          isLongText: true,
                          width: SizeConfig.getPercentWidth(percent: .58),
                        ),
                      ],
                    ),
                    currentAccountPicture: StorageServices.getInstance()
                        .loadData(key: FrontImageKeyStorage()) ==
                        ""
                        ? const CircleAvatar(
                      backgroundImage:
                      AssetImage('assets/images/default_user.jpg'),
                    )
                        : CircleAvatar(
                      radius: MediaQuery
                          .of(context)
                          .size
                          .width / 5,
                      backgroundColor: Colors.grey.shade800,
                      backgroundImage: NetworkImage(
                        StorageServices.getInstance()
                            .loadData(key: FrontImageKeyStorage())!,
                      ),
                    ),
                    decoration: const BoxDecoration(color: kPrimaryColor),
                  );
                }),
            GestureDetector(
              onTap: () {
                CustomDialog.dialogEditProfile(
                  StorageServices.getInstance()
                      .loadData(key: UsernameKeyStorage())!,
                  StorageServices.getInstance()
                      .loadData(key: AddressStorage())!,
                  context,
                );
              },
              child: ListTile(
                title: CustomText(
                    text: "Change Name and Address", typeStyle: SubTitleText()),
                leading: const Icon(Icons.edit),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: ListTile(
                title: CustomText(text: "Language", typeStyle: SubTitleText()),
                leading: const Icon(Icons.language),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: ListTile(
                title: CustomText(text: "Mode", typeStyle: SubTitleText()),
                leading: const Icon(Icons.dark_mode),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(conversationScreen);
              },
              child: ListTile(
                title: CustomText(text: "Chat", typeStyle: SubTitleText()),
                leading: const Icon(Icons.message),
              ),
            ),
            if (!widget.isChief!)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(cartScreen);
                },
                child: ListTile(
                  title: CustomText(text: "Cart", typeStyle: SubTitleText()),
                  leading: const Icon(Icons.shopping_cart),
                ),
              ),
            if (!widget.isChief!)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(orderUserScreen);
                },
                child: ListTile(
                  title: CustomText(text: "myOrder", typeStyle: SubTitleText()),
                  leading: const Icon(Icons.request_page),
                ),
              ),

            GestureDetector(
              onTap: () {
                StorageServices.getInstance().removeAll();
                BlocProvider.of<AuthenticationCubit>(context).signOut();
                Navigator.of(context).pushReplacementNamed(loginScreen);
              },
              child: ListTile(
                title: CustomText(text: "Log out", typeStyle: SubTitleText()),
                leading: const Icon(Icons.logout),
              ),
            ),
            GestureDetector(
              onTap: () async {
                CustomDialog.dialogSure(context);
              },
              child: ListTile(
                title: CustomText(
                  text: "Delete Account",
                  typeStyle: SubTitleText(),
                ),
                leading: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: widget.currentIndex!,
          selectedItemColor: kPrimaryColor,
          onTap: (index) {
            setState(() {
              widget.currentIndex = index;
              if (index == 0) {
                BlocProvider.of<MealControllerCubit>(context)
                    .getAllMeal(stateFetch: AllMealFetch());
              }
            });
          },
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(widget.isChief! ? Icons.person_pin : Icons.favorite),
              label: widget.isChief! ? 'Profile' : 'Favorite',
            ),
            if (widget.isChief!)
              const BottomNavigationBarItem(
                  icon: Icon(Icons.menu), label: 'Orders'),
          ]),
      body: (widget.isChief!
          ? screensChief[widget.currentIndex!]
          : screensUsers[widget.currentIndex!]),
    );
  }
}
