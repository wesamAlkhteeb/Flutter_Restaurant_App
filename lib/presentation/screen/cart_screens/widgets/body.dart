import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rest_app/bussiness_logic/cart_controller_cubit.dart';
import 'package:rest_app/constant/size_config.dart';
import 'package:rest_app/constant/themes.dart';
import 'package:rest_app/data/models/cart_model.dart';
import 'package:rest_app/data/models/order_cart_model.dart';
import 'package:rest_app/presentation/screen/cart_screens/widgets/card_cart.dart';

class BodyCart extends StatefulWidget {
  @override
  _BodyCartState createState() => _BodyCartState();
}

class _BodyCartState extends State<BodyCart> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.getPercentWidth(percent: .02),
      ),
      child: BlocBuilder<CartControllerCubit, CartControllerState>(
          builder: (context, state) {
        return ListView.builder(
          itemCount: cartModel.allOrder.length,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.getPercentWidth(percent: .01)),
            child: Dismissible(
              key: Key(cartModel.allOrder[index].id),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                setState(
                  () {
                    BlocProvider.of<CartControllerCubit>(context).removeFormCart(index: index);
                  },
                );
              },
              background: Container(
                color: Colors.redAccent,
                width: double.infinity,
                height: double.infinity,
                child: Row(
                  children: [
                    const Spacer(),
                    Icon(Icons.delete , color: kWhiteColor , size: SizeConfig.getPercentWidth(percent: .1)),
                    SizedBox(
                      width: SizeConfig.getPercentWidth(percent: .1),
                    )
                  ],
                ),
              ),
              child: CartCard(index: index),
            ),
          ),
        );
      }),
    );
  }
}
