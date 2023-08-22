import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rest_app/bussiness_logic/cart_controller_cubit.dart';
import 'package:rest_app/bussiness_logic/meal_controller_cubit.dart';
import 'package:rest_app/bussiness_logic/theme_controller_cubit.dart';
import 'package:rest_app/constant/size_config.dart';
import 'package:rest_app/constant/strings.dart';
import 'package:rest_app/constant/themes.dart';
import 'package:rest_app/data/models/account_model.dart';
import 'package:rest_app/data/models/meal_model.dart';
import 'package:rest_app/data/web_services/authentication/state_Account.dart';
import 'package:rest_app/data/web_services/meal_web_services.dart';
import 'package:rest_app/presentation/screen/add_and_update_meal/add_update_meal.dart';
import 'package:rest_app/presentation/screen/detail_screen/choose_meal_count_widget.dart';
import 'package:rest_app/presentation/widget/custom_text.dart';
import 'package:rest_app/presentation/widget/star_widget.dart';
import 'package:rest_app/services/image_picker_services.dart';
import 'package:rest_app/services/storage_services.dart';

class DetailMealScreen extends StatefulWidget {
  final MealModel meal;
  String? idRestaurant = "";

  DetailMealScreen({
    Key? key,
    required this.meal,
    required this.myMeal,
    required this.idRestaurant,
  }) : super(key: key) {
    isChief = StorageServices.getInstance().loadData(key: TypeKeyStorage()) ==
        ChiefAccount().type;
  }

  bool? isChief, myMeal;

  @override
  State<DetailMealScreen> createState() => _DetailMealScreenState();
}

class _DetailMealScreenState extends State<DetailMealScreen> {
  @override
  initState() {
    BlocProvider.of<CartControllerCubit>(context)
        .addIdRestaurant(idRestaurant: widget.idRestaurant!);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          title: CustomText(
            text: widget.meal.title,
            typeStyle: TitleText(),
          ),
          actions: [
            if (widget.myMeal!)
              GestureDetector(
                onTap: () async {
                  EasyLoading.show(status: "delete meal ");
                  ResponseMessageData? res =
                      await BlocProvider.of<MealControllerCubit>(context)
                          .deleteMeal(
                    idMeal: widget.meal.id,
                  );
                  EasyLoading.dismiss();
                  Fluttertoast.showToast(msg: res!.message);
                  if (res.stateResponse == StateResponse.successfully) {
                    Navigator.of(context).pushReplacementNamed(mainScreen);
                  }
                },
                child: LayoutBuilder(
                  builder: (context, constrain) {
                    return Icon(
                      Icons.delete,
                      size: constrain.maxHeight * .55,
                      color: Colors.white,
                    );
                  },
                ),
              ),
            if (widget.myMeal!)
              SizedBox(
                width: SizeConfig.getPercentWidth(percent: .04),
              ),
            if (widget.myMeal!)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacementNamed(
                    addMealScreen,
                    arguments: {
                      "typeScreen": UpdateMealOperation(),
                      "meal": widget.meal,
                    },
                  );
                },
                child: LayoutBuilder(
                  builder: (context, constrain) {
                    return Icon(
                      Icons.edit,
                      size: constrain.maxHeight * .55,
                      color: Colors.white,
                    );
                  },
                ),
              ),
            if (widget.myMeal!)
              SizedBox(
                width: SizeConfig.getPercentWidth(percent: .04),
              ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    if (widget.myMeal!) {
                      _showMyDialogImage(context);
                    }
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                    ),
                    child: (widget.meal.image == "")
                        ? Image.asset(
                            "assets/images/default_meal.png",
                            fit: BoxFit.fill,
                          )
                        : Image.network(widget.meal.image, fit: BoxFit.fill),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.getPercentHeight(percent: .02),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CustomText(
                              text: "Chief : ",
                              typeStyle: TitleText(),
                              size: 22),
                          CustomText(
                            text: widget.meal.nameRestaurant,
                            typeStyle: SubTitleText(),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.getPercentHeight(percent: .02),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: CustomText(
                              text: "Description : ",
                              typeStyle: TitleText(),
                              size: 22),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: SizeConfig.getPercentWidth(percent: .04)),
                        child: SizedBox(
                          width: double.infinity,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: CustomText(
                              text: widget.meal.description,
                              typeStyle: SubTitleText(),
                              numberLine: 10,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.getPercentHeight(percent: .02),
                      ),
                      Row(
                        children: [
                          CustomText(
                              text: "Price : ",
                              typeStyle: TitleText(),
                              size: 22),
                          CustomText(
                            text: widget.meal.price,
                            typeStyle: SubTitleText(),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.getPercentHeight(percent: .02),
                      ),
                      Row(
                        children: [
                          CustomText(
                              text: "Star : ",
                              typeStyle: TitleText(),
                              size: 22),
                          CustomText(
                            text: "${widget.meal.rating}",
                            typeStyle: SubTitleText(),
                            color: kPrimaryColor,
                          ),
                          const Icon(
                            Icons.star,
                            color: kPrimaryColor,
                          )
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.getPercentHeight(percent: .02),
                      ),
                      if (widget.idRestaurant!.isNotEmpty && !widget.isChief!)
                        ChooseMealCountWidget(
                          idRestaurant: widget.idRestaurant!,
                          mealModel: widget.meal,
                        ),
                      SizedBox(
                        height: SizeConfig.getPercentHeight(percent: .02),
                      ),
                      if (widget.idRestaurant!.isNotEmpty &&!widget.isChief!)
                        StarWidget(
                          height: SizeConfig.getPercentHeight(percent: .15),
                          width: SizeConfig.getPercentWidth(percent: .7),
                          idMeal: widget.meal.id,
                          onAction: () {
                            Navigator.of(context)
                                .pushReplacementNamed(mainScreen);
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showMyDialogImage(BuildContext contextScreen) {
    showDialog<void>(
      context: contextScreen,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext contextDialog) {
        return AlertDialog(
          title: CustomText(
              text: "Change Username .",
              typeStyle: TitleText(),
              size: 20,
              fontWeight: FontWeight.w700),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        String path = await ImagePickerServices.getInstance()
                            .getImageGallery();
                        if (path == "") return;
                        EasyLoading.show(status: "Upload Image..");
                        ResponseMessageData? res =
                            await BlocProvider.of<MealControllerCubit>(
                                    contextScreen)
                                .updateImageMeal(
                                    idMeal: widget.meal.id, path: path);
                        EasyLoading.dismiss();
                        Fluttertoast.showToast(msg: res!.message);

                        Navigator.of(contextDialog).pop();
                        if (res.stateResponse == StateResponse.successfully) {
                          Navigator.of(context)
                              .pushReplacementNamed(mainScreen);
                        }
                      },
                      child: SizedBox(
                        width: SizeConfig.getPercentWidth(percent: .2),
                        child: LayoutBuilder(builder: (context, constrain) {
                          return Icon(
                            Icons.browse_gallery_rounded,
                            size: constrain.maxWidth * .8,
                            color: kGrayColor,
                          );
                        }),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        String path = await ImagePickerServices.getInstance()
                            .getImageCamera();
                        if (path == "") return;
                        EasyLoading.show(status: "Upload Image..");
                        ResponseMessageData? res =
                            await BlocProvider.of<MealControllerCubit>(
                                    contextScreen)
                                .updateImageMeal(
                                    idMeal: widget.meal.id, path: path);
                        EasyLoading.dismiss();
                        Fluttertoast.showToast(msg: res!.message);

                        Navigator.of(contextDialog).pop();
                        if (res.stateResponse == StateResponse.successfully) {
                          Navigator.of(context)
                              .pushReplacementNamed(mainScreen);
                        }
                      },
                      child: SizedBox(
                        width: SizeConfig.getPercentWidth(percent: .2),
                        child: LayoutBuilder(builder: (context, constrain) {
                          return Icon(
                            Icons.camera_alt,
                            size: constrain.maxWidth * .8,
                            color: kGrayColor,
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: CustomText(
                  text: "Cancel", typeStyle: SubTitleText(), size: 16),
              onPressed: () {
                Navigator.of(contextDialog).pop();
              },
            ),
            TextButton(
              child: CustomText(
                text: "Delete Image",
                typeStyle: SubTitleText(),
                fontWeight: FontWeight.w700,
                color: kPrimaryColor,
                size: 16,
              ),
              onPressed: () async {
                Navigator.of(contextDialog).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
