import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rest_app/bussiness_logic/authentication_cubit.dart';
import 'package:rest_app/constant/themes.dart';

class CustomTextFormField extends StatelessWidget {
  String hintText;
  IconData icon;
  TextInputAction action;
  VoidCallback? onPressed;
  String? Function(String?) validate;
  TypeTextField? obscureTypePassword;
  Function(String?) onchange;
  TextEditingController? textEditingController ;

  CustomTextFormField(
      {Key? key,
      required this.hintText,
      required this.icon,
      this.action = TextInputAction.done,
      this.onPressed,
      required this.obscureTypePassword,
      required this.onchange,
      this.textEditingController,
      required this.validate})
      : super(key: key);

  bool getStateVisible(BuildContext context) {
    if (obscureTypePassword is LoginObscureTextField) {
      return BlocProvider.of<AuthenticationCubit>(context).isObscureLogin;
    } else if (obscureTypePassword is FirstRegisterObscureTextField) {
      return BlocProvider.of<AuthenticationCubit>(context).isObscureSignInFirst;
    } else if (obscureTypePassword is SecondRegisterObscureTextField) {
      return BlocProvider.of<AuthenticationCubit>(context)
          .isObscureSignInSecond;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      builder: (context, state) {
        return TextFormField(
          onChanged: onchange,
          textInputAction: action,
          controller: textEditingController,
          keyboardType: obscureTypePassword is EmailTextField
              ? TextInputType.emailAddress
              : (obscureTypePassword is SimpleTextField)
                  ? TextInputType.name
                  : TextInputType.visiblePassword,
          cursorColor: kPrimaryColor,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: IconButton(
              icon: Icon(
                icon,
                color: kPrimaryColor,
              ),
              onPressed: onPressed,
            ),
            suffixIcon: obscureTypePassword is NoneObscureTextField || obscureTypePassword is SimpleTextField || obscureTypePassword is EmailTextField
                ? null
                : GestureDetector(
                    onTap: () {
                      BlocProvider.of<AuthenticationCubit>(context)
                          .changeObscureLogin(obscureTypePassword!);
                    },
                    child: Icon(
                        getStateVisible(context)
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        color: kPrimaryColor),
                  ),
            labelStyle: const TextStyle(
              fontSize: 20,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(width: 1.5),
            ),
          ),
          obscureText: getStateVisible(context),
          validator: validate,
        );
      },
    );
  }
}
