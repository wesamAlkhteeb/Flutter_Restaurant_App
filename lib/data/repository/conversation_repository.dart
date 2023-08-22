

import 'package:rest_app/data/models/conversation_model.dart';
import 'package:rest_app/data/web_services/conversation_web_services.dart';

class ConversationRepository{
  final ConversationWebServices _conversationWebServices = ConversationWebServices();

  Future addConversation({required String idFriend}) async {
    return await _conversationWebServices.addConversation(idFriend: idFriend);
  }

  Future<List<ConversationModel>> getAllConversation()async{
    return await _conversationWebServices.getAllConversation();
  }

}