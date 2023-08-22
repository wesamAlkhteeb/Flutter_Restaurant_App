import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rest_app/bussiness_logic/theme_controller_cubit.dart';
import 'package:rest_app/constant/size_config.dart';
import 'package:rest_app/constant/strings.dart';
import 'package:rest_app/constant/themes.dart';
import 'package:rest_app/data/models/account_model.dart';
import 'package:rest_app/data/web_services/authentication/state_Account.dart';
import 'package:rest_app/presentation/screen/auth_screens/widegets/general_button.dart';
import 'package:rest_app/presentation/screen/auth_screens/widegets/custom_text_form_field.dart';
import 'package:rest_app/presentation/widget/custom_text.dart';

import '../../../bussiness_logic/authentication_cubit.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kWhiteColor,
        body: SingleChildScrollView(
          // scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Image.asset(
                "assets/images/user.png",
              ),
              SizedBox(
                height: SizeConfig.getPercentHeight(percent: .01),
              ),
              fromRegister(),
              SizedBox(
                height: SizeConfig.getPercentHeight(percent: .01),
              ),
              BlocBuilder<AuthenticationCubit, AuthenticationState>(
                  builder: (contextBloc, state) {
                return radioRegister();
              }),
              buttonRegister(),
              SizedBox(
                height: SizeConfig.getPercentHeight(percent: .01),
              ),
              goToLogin(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget fromRegister() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.getPercentHeight(percent: .02)),
        child: Column(
          children: [
            CustomTextFormField(
              onchange: (value) {
                BlocProvider.of<AuthenticationCubit>(context)
                    .changeDataInput(UsernameTextFieldData(), value!);
              },
              hintText: "Username",
              icon: Icons.person,
              action: TextInputAction.next,
              obscureTypePassword: NoneObscureTextField(),
              validate: (value) {
                if (value == null || value.isEmpty) {
                  return "please enter your name.";
                }
                if (value.length < 4) {
                  return "name is short";
                }
                if (value.length > 20) {
                  return "name is long";
                }
                return null;
              },
            ),
            SizedBox(
              height: SizeConfig.getPercentHeight(percent: .01),
            ),
            CustomTextFormField(
              onchange: (value) {
                BlocProvider.of<AuthenticationCubit>(context)
                    .changeDataInput(EmailTextFieldData(), value!);
              },
              obscureTypePassword: EmailTextField(),
              hintText: "Email",
              icon: Icons.email,
              action: TextInputAction.next,
              validate: (value) {
                if (value == null || value.isEmpty) {
                  return "enter your email.";
                }
                if (!RegExp(r"\w+@\w+.\w*$").hasMatch(value)) {
                  return "problem with form email.";
                }
                return null;
              },
            ),
            SizedBox(
              height: SizeConfig.getPercentHeight(percent: .01),
            ),
            CustomTextFormField(
              onchange: (value) {
                BlocProvider.of<AuthenticationCubit>(context)
                    .changeDataInput(PasswordTextFieldData(), value!);
              },
              hintText: "Password",
              obscureTypePassword: FirstRegisterObscureTextField(),
              icon: Icons.key,
              action: TextInputAction.next,
              onPressed: () {},
              validate: (value) {
                if (value == null || value.isEmpty) {
                  return "enter your password.";
                }
                if (value.length < 8) {
                  return "password is short.";
                }
                return null;
              },
            ),
            SizedBox(
              height: SizeConfig.getPercentHeight(percent: .01),
            ),
            CustomTextFormField(
              onchange: (value) {},
              hintText: "Confirm Passowrd",
              obscureTypePassword: SecondRegisterObscureTextField(),
              icon: Icons.key,
              onPressed: () {},
              validate: (value) {
                if (value == null || value.isEmpty) {
                  return "enter your password.";
                }
                if (BlocProvider.of<AuthenticationCubit>(context)
                        .accountModel.password != value) {
                  return "no match password";
                }
                return null;
              },
            ),
            SizedBox(
              height: SizeConfig.getPercentHeight(percent: .01),
            ),
            CustomTextFormField(
              onchange: (value) {
                BlocProvider.of<AuthenticationCubit>(context)
                    .changeDataInput(AddressTextFieldData(), value!);
              },
              hintText: "enter your address",
              obscureTypePassword: SimpleTextField(),
              icon: Icons.home,
              onPressed: () {},
              validate: (value) {
                if (value == null || value.isEmpty) {
                  return "enter your address.";
                }
                if(value.length < 4 ){
                  return "The address must not be less than 4.";
                }
                if(value.length > 40 ){
                  return "The address must not be more than 40.";
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget radioRegister() {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
        builder: (context, state) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              Radio(
                value: ChiefAccount().type!,
                groupValue: BlocProvider.of<AuthenticationCubit>(context)
                    .state
                    .chiefOrUser,
                activeColor: kPrimaryColor,
                onChanged: (val) {
                  BlocProvider.of<AuthenticationCubit>(context)
                      .changeTypeAccount(ChiefAccount());
                },
              ),
              CustomText(text: "Chief", typeStyle: SubTitleText())
            ],
          ),
          Row(
            children: [
              Radio(
                value: UserAccount().type!,
                groupValue: BlocProvider.of<AuthenticationCubit>(context)
                    .state
                    .chiefOrUser,
                activeColor: kPrimaryColor,
                onChanged: (val) {
                  BlocProvider.of<AuthenticationCubit>(context)
                      .changeTypeAccount(UserAccount());
                },
              ),
              CustomText(text: "User", typeStyle: SubTitleText())
            ],
          ),
        ],
      );
    });
  }

  Widget buttonRegister() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.getPercentHeight(percent: .02),
      ),
      child: GeneralButton(
        onTap: () async {
          if (!_formKey.currentState!.validate()) {
            return;
          }
          if (BlocProvider.of<AuthenticationCubit>(context)
                  .accountModel.typeAccount ==null) {
            Fluttertoast.showToast(
                msg: "Choose Type of Account.", gravity: ToastGravity.BOTTOM);
            return;
          }
          EasyLoading.show(
            status: "Processing",
          );
          ResponseMessageData responseAuthentication =
              await BlocProvider.of<AuthenticationCubit>(context)
                  .signUpWithEmail();
          EasyLoading.dismiss();
          Fluttertoast.showToast(msg: responseAuthentication.message);
          if (responseAuthentication.stateResponse ==
              StateResponse.successfully) {
            Navigator.of(context).pushReplacementNamed(loginScreen);
          }
        },
        text: 'Register',
      ),
    );
  }

  Widget goToLogin(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(
          flex: 4,
        ),
        CustomText(text: 'Do have an account? ', typeStyle: SubTitleText()),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(loginScreen);
          },
          child: CustomText(
            text: 'Log in',
            typeStyle: SubTitleButton(),
          ),
        ),
        const Spacer(
          flex: 1,
        ),
      ],
    );
  }
}
