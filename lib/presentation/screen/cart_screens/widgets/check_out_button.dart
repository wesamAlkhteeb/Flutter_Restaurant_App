import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rest_app/bussiness_logic/cart_controller_cubit.dart';
import 'package:rest_app/bussiness_logic/theme_controller_cubit.dart';
import 'package:rest_app/constant/size_config.dart';
import 'package:rest_app/constant/themes.dart';
import 'package:rest_app/presentation/widget/custom_text.dart';

class CheckoutCard extends StatelessWidget {
  CheckoutCard({
    Key? key,
  }) : super(key: key);

  bool clickOrder = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BlocBuilder<CartControllerCubit, CartControllerState>(
            builder: (context, state) {
              return Text.rich(
                TextSpan(
                  text: "Total:\n",
                  children: [
                    TextSpan(
                      text:
                          "${BlocProvider.of<CartControllerCubit>(context).getSumPrice()} SYP",
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            },
          ),
          SizedBox(
            width: SizeConfig.getPercentWidth(percent: .5),
            height: SizeConfig.getPercentHeight(percent: .08),
            child: MaterialButton(
              onPressed: () async{
                if(!clickOrder){
                  Fluttertoast.showToast(msg: "please waiting while process your order.");
                  return;
                }
                clickOrder = false;
                if (cartModel.allOrder.isNotEmpty ) {

                  await BlocProvider.of<CartControllerCubit>(context)
                      .checkOutCart()
                      .then((value) {
                    Fluttertoast.showToast(msg: value);
                    BlocProvider.of<CartControllerCubit>(context).clearOrders();

                  }).onError((error, stackTrace) {
                    Fluttertoast.showToast(msg: "An error occurred while ordering.");
                  });
                } else {
                  Fluttertoast.showToast(msg: "Please choose many meals.");
                }
                clickOrder = true;
              },
              color: Colors.amber,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              child: CustomText(
                text: "Check Out",
                typeStyle: TitleText(),
                color: kWhiteColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
