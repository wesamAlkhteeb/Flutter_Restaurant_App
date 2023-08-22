

class ConversationModel {
  String idConversation , idFriend ;
  String? image , name;

  @override
  String toString() {
    return 'ConversationModel{idConversation: $idConversation, idFriend: $idFriend, image: $image, name: $name}';
  }

  ConversationModel({required this.idConversation, required this.idFriend , this.name , this.image});
}