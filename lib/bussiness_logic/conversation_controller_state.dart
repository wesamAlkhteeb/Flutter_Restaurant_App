part of 'conversation_controller_cubit.dart';

@immutable
abstract class ConversationControllerState {
  List<ConversationModel> conversations=[];
}

class ConversationControllerLoadingState extends ConversationControllerState {}
class ConversationControllerDoneState extends ConversationControllerState {
  ConversationControllerDoneState({required List<ConversationModel> conversations}){
    super.conversations = conversations;
  }
}
class ConversationControllerErrorState extends ConversationControllerState {}
