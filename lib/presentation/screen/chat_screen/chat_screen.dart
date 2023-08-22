import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rest_app/bussiness_logic/chat_controller_cubit.dart';
import 'package:rest_app/bussiness_logic/theme_controller_cubit.dart';
import 'package:rest_app/constant/size_config.dart';
import 'package:rest_app/constant/themes.dart';
import 'package:rest_app/presentation/screen/chat_screen/message_widget.dart';
import 'package:rest_app/presentation/screen/main_screens/widget/custom_text_field.dart';
import 'package:rest_app/presentation/widget/custom_text.dart';
import 'package:rest_app/services/storage_services.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key, required this.idConversation , required this.nameFriend}) : super(key: key);

  String idConversation;
  String nameFriend;

  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ChatControllerCubit>(context).messageModel.idConversation =
        idConversation;
    BlocProvider.of<ChatControllerCubit>(context).messageModel.idSended =
        StorageServices.getInstance().loadData(key: TokenKeyStorage())!;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: CustomText(
            text: nameFriend,
            typeStyle: TitleText(),
          ),
          backgroundColor: kPrimaryColor,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.getPercentWidth(percent: .05),
              vertical: SizeConfig.getPercentHeight(percent: .01),
            ),
            child: Column(
              children: [
                Container(
                  width: SizeConfig.getPercentWidth(percent: .9),
                  height: SizeConfig.getPercentHeight(percent: .75),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: BlocProvider.of<ChatControllerCubit>(context)
                        .getMessages(),
                    builder:
                        (ctxStream, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: CustomText(
                            text: "Error in Loading",
                            typeStyle: TitleText(),
                          ),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: kPrimaryColor,
                          ),
                        );
                      } else {
                        return ListView.builder(
                          physics: const ScrollPhysics(),
                          itemBuilder: (ctxList, index) {
                            return MessageWidget(
                              text: snapshot.data!.docs[index]["message"],
                              isCurrentUser:
                                  snapshot.data!.docs[index]["idSender"] ==
                                      StorageServices.getInstance().loadData(
                                        key: TokenKeyStorage(),
                                      ),
                            );
                          },
                          itemCount: snapshot.data!.docs.length,
                          reverse: true,
                        );
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: SizeConfig.getPercentHeight(percent: .02),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: SizeConfig.getPercentWidth(percent: .75),
                      child: CustomTextField(
                        hintText: "New Message",
                        onchange: (message) {
                          BlocProvider.of<ChatControllerCubit>(context)
                              .messageModel
                              .message = message!;
                        },
                        typeStyle: SubTitleText(),
                        textEditingController: textEditingController,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        textEditingController.text = "";
                        await BlocProvider.of<ChatControllerCubit>(context)
                            .sendMessage();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(45),
                          color: kPrimaryColor,
                        ),
                        width: SizeConfig.getPercentWidth(percent: .13),
                        height: SizeConfig.getPercentWidth(percent: .13),
                        child: Icon(
                          Icons.send,
                          size: SizeConfig.getPercentWidth(percent: .08),
                          color: kWhiteColor,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
