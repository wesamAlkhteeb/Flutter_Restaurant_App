import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rest_app/bussiness_logic/order_controller_cubit.dart';
import 'package:rest_app/bussiness_logic/theme_controller_cubit.dart';
import 'package:rest_app/constant/size_config.dart';
import 'package:rest_app/constant/themes.dart';
import 'package:rest_app/data/models/account_model.dart';
import 'package:rest_app/presentation/screen/detail_order_screens/detail_order_screen.dart';
import 'package:rest_app/presentation/screen/main_screens/order_status/widget/item_order_widge.dart';
import 'package:rest_app/presentation/screen/main_screens/order_status/widget/type_list_widget.dart';
import 'package:rest_app/presentation/widget/custom_text.dart';
import 'package:rest_app/services/storage_services.dart';

class OrderStatusScreen extends StatefulWidget {
  OrderStatusScreen({Key? key}) : super(key: key);


  @override
  State<OrderStatusScreen> createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  @override
  initState() {
    BlocProvider.of<OrderControllerCubit>(context).getOrdersForChief();
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TypeListOrderWidget(
                onTap: () {
                  BlocProvider.of<OrderControllerCubit>(context)
                      .changeChoose(false);
                },
                text: "New Order",
                isSelected: () {
                  return !BlocProvider.of<OrderControllerCubit>(context).choose;
                },
              ),
              TypeListOrderWidget(
                onTap: () {
                  BlocProvider.of<OrderControllerCubit>(context)
                      .changeChoose(true);
                },
                text: "In Preparation",
                isSelected: () {
                  return BlocProvider.of<OrderControllerCubit>(context).choose;
                },
              ),
            ],
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
                  height: SizeConfig.getPercentHeight(percent: .65),
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

/*

  return BlocProvider.of<OrderControllerCubit>(context).choose
                  ? Expanded(
                      child: ListView.builder(
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                ),
                                color: Colors.grey[400],
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetailsOrdersScreen(),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                                radius: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    7,
                                                backgroundColor:
                                                    Colors.grey.shade800,
                                                backgroundImage: AssetImage(
                                                    'assets/images/9987-2.jpg')),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              height: 170,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text('User Name'),
                                                  SizedBox(
                                                    height: 2,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          height: 170,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text('amount'),
                                              Row(
                                                children: [
                                                  GestureDetector(
                                                    child: Container(
                                                      height: 40,
                                                      width: 70,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
                                                          color: kPrimaryColor),
                                                      child: Center(
                                                          child: Text("Ok")),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 30,
                                                  ),
                                                  GestureDetector(
                                                    child: Container(
                                                      height: 40,
                                                      width: 70,
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Colors.redAccent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50)),
                                                      child: Center(
                                                          child: Text("No")),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    )
                  : Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: 100,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: const BoxDecoration(boxShadow: []),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const DetailsOrdersScreen()));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                              radius: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  7,
                                              backgroundColor:
                                                  Colors.grey.shade800,
                                              backgroundImage: AssetImage(
                                                  'assets/images/9987-2.jpg')),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            height: 170,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text('User Name'),
                                                SizedBox(
                                                  height: 2,
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: 170,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text('amount'),
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  child: Container(
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                          color: kPrimaryColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50)),
                                                      width: 70,
                                                      child: Center(
                                                          child:
                                                              Text("Finish"))),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );

 */
