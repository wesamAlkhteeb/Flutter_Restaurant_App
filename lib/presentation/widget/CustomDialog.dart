import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rest_app/bussiness_logic/authentication_cubit.dart';
import 'package:rest_app/bussiness_logic/theme_controller_cubit.dart';
import 'package:rest_app/constant/size_config.dart';
import 'package:rest_app/constant/strings.dart';
import 'package:rest_app/constant/themes.dart';
import 'package:rest_app/data/web_services/authentication/authontication_web_services.dart';
import 'package:rest_app/data/web_services/authentication/state_Account.dart';
import 'package:rest_app/presentation/screen/auth_screens/widegets/custom_text_form_field.dart';
import 'package:rest_app/presentation/widget/custom_text.dart';
import 'package:rest_app/presentation/widget/star_widget.dart';
import 'package:rest_app/services/image_picker_services.dart';
import 'package:rest_app/services/storage_services.dart';

class CustomDialog {
  static dialogEditProfile(
      String sName, String sAddress, BuildContext context) async {
    TextEditingController nameControl, addressControl;
    nameControl = TextEditingController(text: sName);
    addressControl = TextEditingController(text: sAddress);
    BlocProvider.of<AuthenticationCubit>(context).accountModel.username = sName;
    BlocProvider.of<AuthenticationCubit>(context).accountModel.address =
        sAddress;
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext newContext) {
        return BlocProvider.value(
            value: BlocProvider.of<AuthenticationCubit>(context),
            child: AlertDialog(
              title: CustomText(
                text: "Change Username Or Address.",
                typeStyle: TitleText(),
                size: 20,
                fontWeight: FontWeight.w700,
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    CustomTextFormField(
                      hintText: "Username",
                      icon: Icons.person,
                      obscureTypePassword: SimpleTextField(),
                      onchange: (value) {
                        BlocProvider.of<AuthenticationCubit>(context)
                            .accountModel
                            .username = value!;
                      },
                      textEditingController: nameControl,
                      validate: (val) => null,
                    ),
                    SizedBox(
                      height: SizeConfig.getPercentHeight(percent: .02),
                    ),
                    CustomTextFormField(
                      hintText: "Address",
                      textEditingController: addressControl,
                      icon: Icons.home,
                      obscureTypePassword: SimpleTextField(),
                      onchange: (value) {
                        BlocProvider.of<AuthenticationCubit>(context)
                            .accountModel
                            .address = value!;
                      },
                      validate: (val) => null,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: CustomText(
                      text: "Cancel", typeStyle: SubTitleText(), size: 16),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: CustomText(
                    text: "Update",
                    typeStyle: SubTitleText(),
                    fontWeight: FontWeight.w700,
                    color: kPrimaryColor,
                    size: 16,
                  ),
                  onPressed: () async {
                    if (BlocProvider.of<AuthenticationCubit>(context)
                            .validUserName() !=
                        null) {
                      Fluttertoast.showToast(
                        msg: BlocProvider.of<AuthenticationCubit>(context)
                            .validUserName()!,
                        gravity: ToastGravity.BOTTOM,
                      );
                      return;
                    }
                    if (BlocProvider.of<AuthenticationCubit>(context)
                            .validAddress() !=
                        null) {
                      Fluttertoast.showToast(
                        msg: BlocProvider.of<AuthenticationCubit>(context)
                            .validAddress()!,
                        gravity: ToastGravity.BOTTOM,
                      );
                      return;
                    }
                    ResponseMessageData r =
                        await BlocProvider.of<AuthenticationCubit>(context)
                            .updateNameAndAddress(true);
                    if (r.stateResponse == StateResponse.error) {
                      Fluttertoast.showToast(
                          msg: "error in update", gravity: ToastGravity.BOTTOM);
                    } else {
                      Fluttertoast.showToast(
                          msg: r.message, gravity: ToastGravity.BOTTOM);
                      StorageServices.getInstance().saveData(
                          key: UsernameKeyStorage(),
                          value: BlocProvider.of<AuthenticationCubit>(context)
                              .accountModel
                              .username);
                      BlocProvider.of<AuthenticationCubit>(context)
                          .getDataProfile();
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ));
      },
    );
  }

  static dialogImage(ImageUpdateType imageUpdateType, BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext newContext) {
        return BlocProvider.value(
            value: BlocProvider.of<AuthenticationCubit>(context),
            child: AlertDialog(
              title: CustomText(
                  text: imageUpdateType is BackImageUpdateType?"Change background Image .":"Change Foreground Image.",
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
                            String path =
                                await ImagePickerServices.getInstance()
                                    .getImageGallery();
                            if (path == "") return;
                            BlocProvider.of<AuthenticationCubit>(context)
                                .updateImageProfile(
                                    path: path,
                                    imageUpdateType: imageUpdateType);
                            Navigator.of(context).pop();
                          },
                          child: SizedBox(
                            width: SizeConfig.getPercentWidth(percent: .2),
                            child: LayoutBuilder(builder: (context, constrain) {
                              return Icon(
                                Icons.collections,
                                size: constrain.maxWidth * .8,
                                color: kGrayColor,
                              );
                            }),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            String path =
                                await ImagePickerServices.getInstance()
                                    .getImageCamera();
                            if (path == "") return;
                            BlocProvider.of<AuthenticationCubit>(context)
                                .updateImageProfile(
                                    path: path,
                                    imageUpdateType: imageUpdateType);
                            Navigator.of(context).pop();
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
                    Navigator.of(context).pop();
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
                    BlocProvider.of<AuthenticationCubit>(context)
                        .deleteImageProfile(imageUpdateType: imageUpdateType);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
      },
    );
  }

  static dialogSure(BuildContext context) {
    String sure = "";
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext newContext) {
        return BlocProvider.value(
          value: BlocProvider.of<AuthenticationCubit>(context),
          child: AlertDialog(
            title: CustomText(
                text: "Delete Account .",
                typeStyle: TitleText(),
                size: 20,
                fontWeight: FontWeight.w700),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  CustomTextFormField(
                    hintText: "Enter word 'delete'",
                    icon: Icons.delete,
                    obscureTypePassword: SimpleTextField(),
                    onchange: (value) {
                      sure = value!;
                    },
                    validate: (value) {
                      return null;
                    },
                  )
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: CustomText(
                    text: "Cancel", typeStyle: SubTitleText(), size: 16),
                onPressed: () {
                  Navigator.of(context).pop();
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
                  if (sure == "delete") {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacementNamed(loginScreen);
                    await BlocProvider.of<AuthenticationCubit>(context)
                        .deleteAccount();
                    StorageServices.getInstance().removeAll();
                  } else {
                    Fluttertoast.showToast(
                        msg: "Enter 'delete' if you want delete account",
                        gravity: ToastGravity.BOTTOM);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
