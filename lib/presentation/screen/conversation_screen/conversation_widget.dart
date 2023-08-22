import 'package:flutter/material.dart';
import 'package:rest_app/bussiness_logic/theme_controller_cubit.dart';
import 'package:rest_app/constant/size_config.dart';
import 'package:rest_app/constant/strings.dart';
import 'package:rest_app/constant/themes.dart';
import 'package:rest_app/data/models/conversation_model.dart';
import 'package:rest_app/presentation/widget/custom_text.dart';

class ConversationWidget extends StatelessWidget {
  ConversationWidget({Key? key, required this.conversationModel})
      : super(key: key);
  ConversationModel conversationModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: SizeConfig.getPercentWidth(percent: .9),
        height: SizeConfig.getPercentHeight(percent: .12),
        margin: EdgeInsets.only(bottom: SizeConfig.getPercentWidth(percent: .05)),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(45), color: kGrayColor),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(45),
              child: conversationModel.image!.isEmpty
                  ? Image.asset("assets/images/default_user.jpg")
                  : Image.network(conversationModel.image!),
            ),
            SizedBox(
              width: SizeConfig.getPercentWidth(percent: .05),
            ),
            CustomText(
              text: conversationModel.name!,
              typeStyle: TitleText(),
              color: kWhiteColor,
              size: SizeConfig.getPercentWidth(percent: .07),
              isLongText: true,
              width: SizeConfig.getPercentWidth(percent: .5),
            ),
          ],
        ),
      ),
      onTap: (){
        Navigator.of(context).pushNamed(chatScreen , arguments: [conversationModel.idConversation , conversationModel.name!]);
      },
    );
  }
}
