
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rest_app/data/models/message_model.dart';
import 'package:rest_app/data/web_services/chat_web_services.dart';

class ChatRepository{
  final ChatWebServices _chatWebServices = ChatWebServices();
  Future<void> sendMessage({required MessageModel messageModel}) async {
    await _chatWebServices.sendMessage(messageModel: messageModel);
  }

  Stream<QuerySnapshot> getMessages({required MessageModel messageModel}) {
    return _chatWebServices.getMessages(messageModel: messageModel);
  }

}