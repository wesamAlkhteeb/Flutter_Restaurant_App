


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rest_app/bussiness_logic/order_controller_cubit.dart';
import 'package:rest_app/bussiness_logic/theme_controller_cubit.dart';
import 'package:rest_app/constant/size_config.dart';
import 'package:rest_app/constant/themes.dart';
import 'package:rest_app/data/models/account_model.dart';
import 'package:rest_app/presentation/screen/main_screens/order_status/widget/item_order_widge.dart';
import 'package:rest_app/presentation/screen/main_screens/order_status/widget/type_list_widget.dart';
import 'package:rest_app/presentation/widget/custom_text.dart';
import 'package:rest_app/services/storage_services.dart';

class OrderUserScreen extends StatefulWidget {
  const OrderUserScreen({Key? key}) : super(key: key);

  @override
  State<OrderUserScreen> createState() => _OrderUserScreenState();
}

class _OrderUserScreenState extends State<OrderUserScreen> {

  @override
  initState() {
    BlocProvider.of<OrderControllerCubit>(context).getOrdersForUser();

  }

  OrderState getOrderState(String state) {
    if (state == NewOrderState().state) {
      return NewOrderState();
    } else if (state == AcceptOrderState().state) {
      return AcceptOrderState();
    } else {
      return FinishOrderState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.getPercentWidth(percent: .05)),
      child: Column(
        children: [
          SizedBox(
            height: SizeConfig.getPercentHeight(percent: .05),
          ),
          Center(
            child: CustomText(
              text: "Orders",
              typeStyle: TitleText(),
              size: SizeConfig.getPercentWidth(percent: .1),
            ),
          ),
          SizedBox(
            height: SizeConfig.getPercentHeight(percent: .02),
          ),
          BlocBuilder<OrderControllerCubit, OrderControllerState>(
            builder: (ctxBloc, state) {
              if (state is OrderControllerDone) {
                if ((BlocProvider.of<OrderControllerCubit>(context).choose &&
                    state.haveOrders.isEmpty )|| (!BlocProvider.of<OrderControllerCubit>(context).choose &&
                    state.newOrders.isEmpty) ) {
                  return Center(
                    child: CustomText(
                      text: "Don't have any order",
                      typeStyle: TitleText(),
                    ),
                  );
                }
                return SizedBox(
                  height: SizeConfig.getPercentHeight(percent: .85),
                  child: ListView.builder(
                    itemBuilder: (ctxList, index) {
                      return ItemOrderWidget(
                        orderState: getOrderState(
                          BlocProvider.of<OrderControllerCubit>(context).choose
                              ? state.haveOrders[index].state
                              : state.newOrders[index].state,
                        ),
                        orderModel:
                        (BlocProvider.of<OrderControllerCubit>(context)
                            .choose)
                            ? state.haveOrders[index]
                            : state.newOrders[index],
                      );
                    },
                    itemCount:
                    (BlocProvider.of<OrderControllerCubit>(context).choose)
                        ? state.haveOrders.length
                        : state.newOrders.length,
                  ),
                );
              } else if (state is OrderControllerLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: kPrimaryColor,
                  ),
                );
              } else {
                return Center(
                  child: CustomText(
                    text: "Error in Load",
                    typeStyle: TitleText(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
