import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rest_app/bussiness_logic/meal_controller_cubit.dart';
import 'package:rest_app/bussiness_logic/theme_controller_cubit.dart';
import 'package:rest_app/constant/size_config.dart';
import 'package:rest_app/constant/strings.dart';
import 'package:rest_app/constant/themes.dart';
import 'package:rest_app/data/models/meal_model.dart';
import 'package:rest_app/data/web_services/authentication/state_Account.dart';
import 'package:rest_app/presentation/screen/main_screens/widget/custom_text_field.dart';
import 'package:rest_app/presentation/widget/custom_text.dart';
import 'package:rest_app/services/image_picker_services.dart';

class SetMealScreen extends StatefulWidget {
  SetMealScreen(
      {Key? key, required this.typeOperationMealScreen, this.mealModel})
      : super(key: key);

  TypeOperationMealScreen typeOperationMealScreen;
  MealModel? mealModel;

  @override
  State<SetMealScreen> createState() => _SetMealScreenState();
}

class _SetMealScreenState extends State<SetMealScreen> {
  @override
  Widget build(BuildContext context) {
    if (widget.typeOperationMealScreen is UpdateMealOperation) {
      BlocProvider.of<MealControllerCubit>(context).mealModel =
          widget.mealModel!;
    }
    SizeConfig(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height);
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: widget.typeOperationMealScreen.titleAppBar!,
          typeStyle: TitleText(),
        ),
        backgroundColor: kPrimaryColor,
        actions: [
          GestureDetector(
            onTap: () async {
              String validate = BlocProvider.of<MealControllerCubit>(context)
                  .checkAllInputText(widget.typeOperationMealScreen);
              if (validate != "") {
                Fluttertoast.showToast(
                  msg: validate,
                  gravity: ToastGravity.BOTTOM,
                );
                return;
              }

              EasyLoading.show(status: "adding");
              ResponseMessageData? res =
                  ResponseMessageData("error", StateResponse.error);
              if (widget.typeOperationMealScreen is AddMealOperation) {
                res = await BlocProvider.of<MealControllerCubit>(context)
                    .addMeal();
              } else {
                BlocProvider.of<MealControllerCubit>(context).changeData(
                    inputMealData: IDInputMealData(),
                    data: widget.mealModel!.id);
                res = await BlocProvider.of<MealControllerCubit>(context)
                    .updateMeal();
              }
              EasyLoading.dismiss();
              Fluttertoast.showToast(msg: res!.message);
              if (res != null &&
                  res.stateResponse == StateResponse.successfully) {
                Navigator.of(context).pushReplacementNamed(mainScreen);
              }
            },
            child: LayoutBuilder(builder: (context, constrain) {
              return Icon(
                widget.typeOperationMealScreen is AddMealOperation
                    ? Icons.add
                    : Icons.edit,
                size: constrain.maxHeight * .6,
              );
            }),
          ),
          SizedBox(
            width: SizeConfig.getPercentWidth(percent: .02),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.getPercentWidth(percent: .02),
          vertical: SizeConfig.getPercentHeight(percent: .04),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTextField(
                hintText: "Name Meal",
                onchange: (value) {
                  BlocProvider.of<MealControllerCubit>(context).changeData(
                      inputMealData: NameInputMealData(), data: value!);
                },
                typeStyle: SubTitleText(),
                textEditingController:
                    widget.typeOperationMealScreen is UpdateMealOperation
                        ? TextEditingController(text: BlocProvider.of<MealControllerCubit>(context).mealModel.title)
                        : null,
              ),
              SizedBox(
                height: SizeConfig.getPercentHeight(percent: .02),
              ),
              CustomTextField(
                hintText: "Description Meal",
                onchange: (value) {
                  BlocProvider.of<MealControllerCubit>(context).changeData(
                      inputMealData: DescriptionInputMealData(), data: value!);
                },
                typeStyle: SubTitleText(),
                textEditingController: widget.typeOperationMealScreen
                        is UpdateMealOperation
                    ? TextEditingController(text: BlocProvider.of<MealControllerCubit>(context).mealModel.description)
                    : null,
              ),
              SizedBox(
                height: SizeConfig.getPercentHeight(percent: .02),
              ),
              CustomTextField(
                hintText: "Price Meal",
                onchange: (value) {
                  BlocProvider.of<MealControllerCubit>(context).changeData(
                      inputMealData: PriceInputMealData(), data: value!);
                },
                typeStyle: SubTitleText(),
                textInputType: TextInputType.number,
                textEditingController:
                    widget.typeOperationMealScreen is UpdateMealOperation
                        ? TextEditingController(text: BlocProvider.of<MealControllerCubit>(context).mealModel.price)
                        : null,
              ),
              SizedBox(
                height: SizeConfig.getPercentHeight(percent: .04),
              ),
              if (widget.typeOperationMealScreen is AddMealOperation)
                GestureDetector(
                  onTap: () {
                    _showMyDialogImage(context);
                  },
                  child: Container(
                    width: double.infinity,
                    height: SizeConfig.getPercentHeight(percent: .1),
                    decoration: const BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Center(
                      child: CustomText(
                        text: "Choose Image",
                        typeStyle: TitleText(),
                      ),
                    ),
                  ),
                )
            ],
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
                        BlocProvider.of<MealControllerCubit>(contextScreen)
                            .changeData(
                                inputMealData: ImageInputMealData(),
                                data: path);
                        Navigator.of(contextDialog).pop();
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
                        BlocProvider.of<MealControllerCubit>(contextScreen)
                            .changeData(
                                inputMealData: ImageInputMealData(),
                                data: path);
                        Navigator.of(contextDialog).pop();
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
          ],
        );
      },
    );
  }
}

abstract class TypeOperationMealScreen {
  String? titleAppBar;
}

class AddMealOperation extends TypeOperationMealScreen {
  AddMealOperation() {
    titleAppBar = "Add Meal";
  }
}

class UpdateMealOperation extends TypeOperationMealScreen {
  UpdateMealOperation() {
    titleAppBar = "Update Meal";
  }
}
