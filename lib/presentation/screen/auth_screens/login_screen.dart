import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rest_app/bussiness_logic/authentication_cubit.dart';
import 'package:rest_app/bussiness_logic/theme_controller_cubit.dart';
import 'package:rest_app/constant/size_config.dart';
import 'package:rest_app/constant/strings.dart';
import 'package:rest_app/constant/themes.dart';
import 'package:rest_app/data/web_services/authentication/state_Account.dart';
import 'package:rest_app/presentation/screen/auth_screens/widegets/general_button.dart';
import 'package:rest_app/presentation/screen/auth_screens/widegets/custom_text_form_field.dart';
import 'package:rest_app/presentation/widget/custom_text.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height);
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
              formLogIn(context),
              SizedBox(
                height: SizeConfig.getPercentHeight(percent: .06),
              ),
              buttonLogin(context),
              SizedBox(
                height: SizeConfig.getPercentHeight(percent: .04),
              ),
              goToSignUp(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget formLogIn(BuildContext context) {
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
                    .changeDataInput(EmailTextFieldData(), value!);
              },
              hintText: "Email",
              icon: Icons.email,
              action: TextInputAction.next,
              obscureTypePassword: EmailTextField(),
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
              height: SizeConfig.getPercentHeight(percent: .02),
            ),
            CustomTextFormField(
              onchange: (value) {
                BlocProvider.of<AuthenticationCubit>(context)
                    .changeDataInput(PasswordTextFieldData(), value!);
              },
              hintText: "Password",
              icon: Icons.key,
              obscureTypePassword: LoginObscureTextField(),
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
          ],
        ),
      ),
    );
  }

  Widget buttonLogin(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.getPercentHeight(percent: .02)),
      child: GeneralButton(
        text: 'Login',
        onTap: () async {
          if (!_formKey.currentState!.validate()) {
            return;
          }
          EasyLoading.show(status: "Processing");
          ResponseMessageData responseAuthentication =
              await BlocProvider.of<AuthenticationCubit>(context)
                  .loginWithEmail();
          EasyLoading.dismiss();
          Fluttertoast.showToast(msg: responseAuthentication.message);
          if (responseAuthentication.stateResponse ==
              StateResponse.successfully) {
            Navigator.of(context).pushReplacementNamed(mainScreen);
          }
        },
      ),
    );
  }

  Widget goToSignUp(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(
          flex: 3,
        ),
        CustomText(text: 'Don\'t have an account? ', typeStyle: SubTitleText()),
        GestureDetector(
          onTap: () {
            // BlocProvider.of<AuthenticationCubit>(context).clearData();
            // print(BlocProvider.of<AuthenticationCubit>(context).isClosed);
            Navigator.of(context)
                .pushReplacementNamed(registerScreen, arguments: context);
          },
          child: CustomText(text: 'Register', typeStyle: SubTitleButton()),
        ),
        const Spacer(
          flex: 1,
        ),
      ],
    );
  }
}
