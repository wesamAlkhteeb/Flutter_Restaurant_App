import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rest_app/data/models/conversation_model.dart';
import 'package:rest_app/data/repository/conversation_repository.dart';

import '../data/models/conversation_model.dart';
import '../data/models/conversation_model.dart';

part 'conversation_controller_state.dart';

class ConversationControllerCubit extends Cubit<ConversationControllerState> {
  ConversationControllerCubit() : super(ConversationControllerDoneState(conversations: []));

  final ConversationRepository _conversationRepository = ConversationRepository();


  Future addConversation({required String idFriend}) async {
    return _conversationRepository.addConversation(idFriend: idFriend);
  }

  getAllConversation()async{
    emit(ConversationControllerLoadingState());
    await _conversationRepository.getAllConversation().then((value) {
      print(value.length);
      emit(ConversationControllerDoneState(conversations: value));
    }).onError((error, stackTrace) {
      emit(ConversationControllerErrorState());
    });
  }
}
