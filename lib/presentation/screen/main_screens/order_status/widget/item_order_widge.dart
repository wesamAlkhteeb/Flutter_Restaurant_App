import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rest_app/bussiness_logic/order_controller_cubit.dart';
import 'package:rest_app/bussiness_logic/theme_controller_cubit.dart';
import 'package:rest_app/constant/size_config.dart';
import 'package:rest_app/constant/strings.dart';
import 'package:rest_app/constant/themes.dart';
import 'package:rest_app/data/models/account_model.dart';
import 'package:rest_app/data/models/order_cart.dart';
import 'package:rest_app/presentation/screen/main_screens/order_status/widget/CustomButtonOrderWidget.dart';
import 'package:rest_app/presentation/widget/custom_text.dart';
import 'package:rest_app/services/storage_services.dart';

class ItemOrderWidget extends StatelessWidget {
  ItemOrderWidget({
    Key? key,
    required this.orderState,
    required this.orderModel,
  }) : super(key: key) {
    isUser = StorageServices.getInstance().loadData(key: TypeKeyStorage()) !=
        ChiefAccount().type;
  }

  bool? isUser;
  OrderState orderState;
  OrderModel orderModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(detailOrderScreen, arguments: orderModel.idOrder);
      },
      child: Dismissible(
        key: Key(orderModel.idOrder),
        direction: orderState.state == FinishOrderState().state ||
                (isUser! && orderState is NewOrderState)
            ? DismissDirection.endToStart
            : DismissDirection.none,
        onDismissed: (direct) {
          BlocProvider.of<OrderControllerCubit>(context)
              .deleteOrder(idOrder: orderModel.idOrder);
        },
        background: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.red,
          ),
          child: Row(
            children: [
              const Spacer(),
              Icon(
                Icons.delete,
                size: SizeConfig.getPercentWidth(percent: .15),
                color: kWhiteColor,
              ),
              SizedBox(
                width: SizeConfig.getPercentWidth(percent: .05),
              )
            ],
          ),
        ),
        child: Container(
          width: SizeConfig.getPercentWidth(percent: .9),
          height: SizeConfig.getPercentHeight(percent: .2),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(color: Colors.black38, spreadRadius: 1, blurRadius: 5),
            ],
          ),
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.getPercentWidth(percent: .02),
            vertical: SizeConfig.getPercentHeight(percent: .01),
          ),
          margin: EdgeInsets.only(
            bottom: SizeConfig.getPercentHeight(percent: .03),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomText(text: "Name : ", typeStyle: TitleText()),
                      CustomText(
                        text: orderModel.nameUser,
                        typeStyle: SubTitleText(),
                        size: SizeConfig.getPercentWidth(percent: .05),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      CustomText(text: "Date : ", typeStyle: TitleText()),
                      CustomText(
                        text: orderModel.date,
                        typeStyle: SubTitleText(),
                        size: SizeConfig.getPercentWidth(percent: .05),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      CustomText(text: "Price : ", typeStyle: TitleText()),
                      CustomText(
                        text: orderModel.totalPrice,
                        typeStyle: SubTitleText(),
                        size: SizeConfig.getPercentWidth(percent: .05),
                      ),
                    ],
                  ),
                ],
              ),
              if (!isUser!)
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomButtonOrderWidget(
                      isHaveBorder:
                          orderState.state == AcceptOrderState().state,
                      width: SizeConfig.getPercentWidth(percent: .35),
                      height: SizeConfig.getPercentHeight(percent: .06),
                      text: orderState.state == NewOrderState().state
                          ? "Accept Order"
                          : "Wait",
                      color: orderState.state == NewOrderState().state
                          ? Colors.green
                          : kPrimaryColor,
                      onTap: () {
                        if (orderState.state == NewOrderState().state) {
                          BlocProvider.of<OrderControllerCubit>(context)
                              .changeState(
                            orderState: AcceptOrderState(),
                            idOrder: orderModel.idOrder,
                          );
                        } else {
                          BlocProvider.of<OrderControllerCubit>(context)
                              .changeState(
                            orderState: AcceptOrderState(),
                            idOrder: orderModel.idOrder,
                          );
                        }
                      },
                    ),
                    CustomButtonOrderWidget(
                      isHaveBorder:
                          orderState.state == FinishOrderState().state,
                      width: SizeConfig.getPercentWidth(percent: .35),
                      height: SizeConfig.getPercentHeight(percent: .06),
                      text: orderState.state == NewOrderState().state
                          ? "Cancel Order"
                          : "Done",
                      color: orderState.state == NewOrderState().state
                          ? Colors.red
                          : kPrimaryColor,
                      onTap: () {
                        if (orderState.state == NewOrderState().state) {
                          BlocProvider.of<OrderControllerCubit>(context)
                              .deleteOrder(
                            idOrder: orderModel.idOrder,
                          );
                        } else {
                          BlocProvider.of<OrderControllerCubit>(context)
                              .changeState(
                            orderState: FinishOrderState(),
                            idOrder: orderModel.idOrder,
                          );
                        }
                      },
                    )
                  ],
                )
              else
                Container(
                  width: SizeConfig.getPercentWidth(percent: .3),
                  height: SizeConfig.getPercentHeight(percent: .1),
                  decoration: const BoxDecoration(
                    color: kWhiteColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: CustomText(
                    text: orderState is NewOrderState ? "not Accept" : (orderState is AcceptOrderState)? "Accept":"Finish",
                    typeStyle: SubTitleText(),
                    fontWeight: FontWeight.w700,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
