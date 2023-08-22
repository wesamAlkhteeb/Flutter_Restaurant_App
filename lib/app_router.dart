import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rest_app/bussiness_logic/authentication_cubit.dart';
import 'package:rest_app/bussiness_logic/cart_controller_cubit.dart';
import 'package:rest_app/bussiness_logic/chat_controller_cubit.dart';
import 'package:rest_app/bussiness_logic/conversation_controller_cubit.dart';
import 'package:rest_app/bussiness_logic/detail_order_controller_cubit.dart';
import 'package:rest_app/bussiness_logic/favorite_controller_cubit.dart';
import 'package:rest_app/bussiness_logic/main_controller_cubit.dart';
import 'package:rest_app/bussiness_logic/meal_controller_cubit.dart';
import 'package:rest_app/bussiness_logic/order_controller_cubit.dart';
import 'package:rest_app/bussiness_logic/restaurants_controller_cubit.dart';
import 'package:rest_app/bussiness_logic/star_controller_cubit.dart';
import 'package:rest_app/bussiness_logic/text_field_controller_cubit.dart';
import 'package:rest_app/constant/strings.dart';
import 'package:rest_app/data/models/meal_model.dart';
import 'package:rest_app/presentation/screen/add_and_update_meal/add_update_meal.dart';
import 'package:rest_app/presentation/screen/auth_screens/Signup_screen.dart';
import 'package:rest_app/presentation/screen/auth_screens/login_screen.dart';
import 'package:rest_app/presentation/screen/cart_screens/cart_screen.dart';
import 'package:rest_app/presentation/screen/chat_screen/chat_screen.dart';
import 'package:rest_app/presentation/screen/conversation_screen/conversation_screen.dart';
import 'package:rest_app/presentation/screen/detail_order_screens/detail_order_screen.dart';
import 'package:rest_app/presentation/screen/detail_screen/detail_Meal_screen.dart';
import 'package:rest_app/presentation/screen/main_screens/main_screen.dart';
import 'package:rest_app/presentation/screen/main_screens/order_status/order_status_screen.dart';
import 'package:rest_app/presentation/screen/main_screens/order_status/order_user_screen.dart';
import 'package:rest_app/presentation/screen/main_screens/profile_chief/profile_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case registerScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => AuthenticationCubit(),
              ),
              BlocProvider(
                create: (_) => TextFieldControllerCubit(),
              ),
            ],
            child: RegisterScreen(),
          ),
        );
      case loginScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => AuthenticationCubit(),
              ),
              BlocProvider(
                create: (_) => TextFieldControllerCubit(),
              ),
            ],
            child: LoginScreen(),
          ),
        );
      case mainScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (contextMainController) => MainControllerCubit(),
              ),
              BlocProvider(
                create: (contextMainController) => OrderControllerCubit(),
              ),
              BlocProvider(
                create: (contextMainController) => AuthenticationCubit(),
              ),
              BlocProvider(
                create: (contextMainController) => MealControllerCubit(),
              ),
              BlocProvider(
                create: (contextMainController) => RestaurantsControllerCubit(),
              ),
              BlocProvider(
                create: (contextMainController) => FavoriteControllerCubit(),
              ),
              BlocProvider(
                create: (contextMainController) => TextFieldControllerCubit(),
              ),
            ],
            child: MainScreen(
                currentIndex: routeSettings.arguments == null
                    ? 0
                    : routeSettings.arguments as int),
          ),
        );

      case detailOrderScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (contextMainController) => DetailOrderControllerCubit(),
              ),
            ],
            child:
                DetailsOrdersScreen(idOrder: routeSettings.arguments as String),
          ),
        );
      case orderUserScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(providers: [
            BlocProvider(
              create: (contextMainController) => OrderControllerCubit(),
            ),
          ], child: const OrderUserScreen()),
        );

      case addMealScreen:
        {
          TypeOperationMealScreen? typeOperationMealScreen;
          if ((routeSettings.arguments as Map<String, dynamic>)["typeScreen"]
              is UpdateMealOperation) {
            typeOperationMealScreen = UpdateMealOperation();
          } else {
            typeOperationMealScreen = AddMealOperation();
          }
          return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (contextMainController) => MealControllerCubit(),
                ),
                BlocProvider(
                  create: (contextMainController) => TextFieldControllerCubit(),
                ),
              ],
              child: SetMealScreen(
                typeOperationMealScreen: typeOperationMealScreen!,
                mealModel:
                    (routeSettings.arguments as Map<String, dynamic>)["meal"],
              ),
            ),
          );
        }
      case detailMealScreen:
        {
          return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (contextMainController) => MealControllerCubit(),
                ),
                BlocProvider(
                  create: (contextMainController) => StarControllerCubit(),
                ),
                BlocProvider(
                  create: (contextMainController) => CartControllerCubit(),
                ),
              ],
              child: DetailMealScreen(
                myMeal: (routeSettings.arguments
                    as Map<String, dynamic>)["myMeal"] as bool,
                meal: (routeSettings.arguments as Map<String, dynamic>)["meal"]
                    as MealModel,
                idRestaurant: (routeSettings.arguments
                    as Map<String, dynamic>)["idRestaurant"] as String,
              ),
            ),
          );
        }
      case profileScreen:
        {
          return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (contextMainController) =>
                      RestaurantsControllerCubit(),
                ),
                BlocProvider(
                  create: (contextMainController) => StarControllerCubit(),
                ),
                BlocProvider(
                  create: (contextMainController) => AuthenticationCubit(),
                ),
                BlocProvider(
                  create: (contextMainController) => MealControllerCubit(),
                ),
                BlocProvider(
                  create: (contextMainController) => FavoriteControllerCubit(),
                ),
                BlocProvider(
                  create: (contextMainController) =>
                      ConversationControllerCubit(),
                ),
              ],
              child: ProfileScreen(
                isChief: (routeSettings.arguments as List)[0] as bool,
                idRestaurant: (routeSettings.arguments as List)[1] as String,
                stateProfileNavigator: (routeSettings.arguments as List)[2],
              ),
            ),
          );
        }
      case conversationScreen:
        {
          return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(providers: [
              BlocProvider(
                create: (contextMainController) =>
                    ConversationControllerCubit(),
              ),
            ], child: const ConversationScreen()),
          );
        }
      case chatScreen:
        {
          return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (contextMainController) => ChatControllerCubit(),
                  ),
                  BlocProvider(
                    create: (contextMainController) =>
                        TextFieldControllerCubit(),
                  ),
                ],
                child: ChatScreen(
                  idConversation: (routeSettings.arguments as List<String>)[0],
                  nameFriend: (routeSettings.arguments as List<String>)[1],
                )),
          );
        }
      case cartScreen:
        {
          return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (contextMainController) => CartControllerCubit(),
                ),
              ],
              child: CartScreen(),
            ),
          );
        }
    }
    return null;
  }
}
