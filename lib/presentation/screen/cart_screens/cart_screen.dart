import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rest_app/bussiness_logic/cart_controller_cubit.dart';
import 'package:rest_app/presentation/screen/cart_screens/widgets/body.dart';
import 'package:rest_app/presentation/screen/cart_screens/widgets/check_out_button.dart';


class CartScreen extends StatelessWidget {
  static String routeName = "/cart_screens";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: BodyCart(),
      bottomNavigationBar: CheckoutCard(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.amber,
      title: Column(
        children: [
          const Text(
            "Your Cart",
            style: TextStyle(color: Colors.black),
          ),
          BlocBuilder<CartControllerCubit , CartControllerState>(
            builder: (context , state) {
              return Text(
                "${cartModel.allOrder.length} items",
                style: Theme.of(context).textTheme.caption,
              );
            }
          ),
        ],
      ),
    );
  }
}