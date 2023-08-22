import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rest_app/bussiness_logic/conversation_controller_cubit.dart';
import 'package:rest_app/bussiness_logic/conversation_controller_cubit.dart';
import 'package:rest_app/bussiness_logic/theme_controller_cubit.dart';
import 'package:rest_app/constant/size_config.dart';
import 'package:rest_app/constant/themes.dart';
import 'package:rest_app/presentation/screen/conversation_screen/conversation_widget.dart';
import 'package:rest_app/presentation/widget/custom_text.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({Key? key}) : super(key: key);

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  @override
  initState() {
    BlocProvider.of<ConversationControllerCubit>(context).getAllConversation();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: CustomText(
            text: "Conversations",
            typeStyle: TitleText(),
          ),
          backgroundColor: kPrimaryColor,
        ),
        body: BlocBuilder<ConversationControllerCubit,
            ConversationControllerState>(
          builder: (context, state) {
            if (state is ConversationControllerErrorState) {
              return Center(
                child: CustomText(
                    text: "Error in Loading", typeStyle: TitleText()),
              );
            } else if (state is ConversationControllerDoneState) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.getPercentWidth(percent: .04),
                  vertical: SizeConfig.getPercentHeight(percent: .02),
                ),
                child: ListView.builder(
                  itemBuilder: (ctx, index) {
                    return ConversationWidget(
                      conversationModel: state.conversations[index],
                    );
                  },
                  itemCount: state.conversations.length,
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  color: kPrimaryColor,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
