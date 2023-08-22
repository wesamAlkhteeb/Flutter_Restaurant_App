import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rest_app/bussiness_logic/detail_order_controller_cubit.dart';
import 'package:rest_app/bussiness_logic/theme_controller_cubit.dart';
import 'package:rest_app/constant/size_config.dart';
import 'package:rest_app/constant/themes.dart';
import 'package:rest_app/presentation/screen/detail_order_screens/widgets/card_details_order.dart';
import 'package:rest_app/presentation/widget/custom_text.dart';

class DetailsOrdersScreen extends StatefulWidget {
  DetailsOrdersScreen({Key? key, required this.idOrder}) : super(key: key);
  String idOrder;

  @override
  State<DetailsOrdersScreen> createState() => _DetailsOrdersScreenState();
}

class _DetailsOrdersScreenState extends State<DetailsOrdersScreen> {
  @override
  initState() {
    BlocProvider.of<DetailOrderControllerCubit>(context)
        .getDetailOrder(idOrder: widget.idOrder);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.getPercentWidth(percent: .04),
            vertical: SizeConfig.getPercentHeight(percent: .02),
          ),
          child: Column(
            children: [
              CustomText(text: "Detail Order", typeStyle: TitleText()),
              SizedBox(
                height: SizeConfig.getPercentHeight(percent: .03),
              ),
              BlocBuilder<DetailOrderControllerCubit, DetailOrderControllerState>(
                  builder: (context, state) {
                if (state is DetailOrderControllerLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: kPrimaryColor,
                    ),
                  );
                } else if (state is DetailOrderControllerError) {
                  return Center(
                      child: CustomText(
                    text: "Can't Loading",
                    typeStyle: TitleText(),
                  ));
                }
                return Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: state.orders.length,
                    itemBuilder: (context, index) {
                      return CardDetailsOrder(
                        mealOrderModel: state.orders[index],
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
