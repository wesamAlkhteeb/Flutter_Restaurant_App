import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:rest_app/data/models/message_model.dart';
import 'package:rest_app/data/repository/chat_repository.dart';
import 'package:rest_app/services/firebase_messageing_services.dart';

part 'chat_controller_state.dart';

class ChatControllerCubit extends Cubit<ChatControllerState> {
  ChatControllerCubit() : super(ChatControllerInitial());

  final ChatRepository _chatRepository = ChatRepository();

  MessageModel messageModel = MessageModel(
      idConversation: "", message: "", idSended: "", dateTime: DateTime.now());

  bool isSend = true;
  sendMessage() async {
    if(messageModel.message.isNotEmpty && isSend){
      isSend = false;
      await _chatRepository.sendMessage(messageModel: messageModel);
      isSend = true;
    }
    messageModel.message = "";
  }

  Stream<QuerySnapshot> getMessages() {
    return _chatRepository.getMessages(messageModel: messageModel);
  }
}
