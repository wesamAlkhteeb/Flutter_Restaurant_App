import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rest_app/bussiness_logic/text_field_controller_cubit.dart';
import 'package:rest_app/constant/themes.dart';

class CustomTextFieldSearch extends StatelessWidget {
  CustomTextFieldSearch({Key? key, required this.onChange}) : super(key: key);

  Function(String? str) onChange;


  @override
  Widget build(BuildContext context) {

    return BlocBuilder<TextFieldControllerCubit, TextDirection>(
        builder: (context, state) {
      return TextFormField(
        textDirection: state,
        decoration: const InputDecoration(
          hintText: "what are looking for ?",
          // hintStyle: TextStyle(fontSize: 13),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        cursorColor: kPrimaryColor,
        onChanged: (str){
          onChange(str);
          BlocProvider.of<TextFieldControllerCubit>(context).changeDirection(str);
        },
      );
    });
  }
}
