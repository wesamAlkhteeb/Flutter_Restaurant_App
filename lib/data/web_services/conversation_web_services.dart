import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rest_app/data/models/account_model.dart';
import 'package:rest_app/data/models/conversation_model.dart';
import 'package:rest_app/services/storage_services.dart';

class ConversationWebServices {
  final String _conversationCollection = "Conversation";
  final String _userCollection = "User";
  final String _idUser = "idUser";
  final String _idRestaurant = "idRestaurant";

  Future addConversation({required String idFriend}) async {
    String? idMe =
        StorageServices.getInstance().loadData(key: TokenKeyStorage());
    bool isUser =
        StorageServices.getInstance().loadData(key: TypeKeyStorage()) ==
            UserAccount().type;

    final conversation = await FirebaseFirestore.instance
        .collection(_conversationCollection)
        .where(isUser ? _idRestaurant : _idUser, isEqualTo: idFriend)
        .where(
          isUser ? _idUser : _idRestaurant,
          isEqualTo: idMe,
        )
        .get();

    if (conversation.docs.isEmpty) {
      print(conversation.docs.length);
      await FirebaseFirestore.instance
          .collection(_conversationCollection)
          .add({_idUser: idMe, _idRestaurant: idFriend});
    }
  }

  Future<List<ConversationModel>> getAllConversation() async {
    String? idMe =
        StorageServices.getInstance().loadData(key: TokenKeyStorage());
    bool isUser =
        StorageServices.getInstance().loadData(key: TypeKeyStorage()) ==
            UserAccount().type;
    List<ConversationModel> conversationList = [];
    try {
      final conversations = await FirebaseFirestore.instance
          .collection(_conversationCollection)
          .where(isUser ? _idUser : _idRestaurant, isEqualTo: idMe)
          .get();
      print(conversations.docs.length);
      for (int i = 0; i < conversations.size; i++) {
        String idConversation = conversations.docs[i].id;
        String idFriend =
            isUser ? conversations.docs[i].data()["idRestaurant"] : conversations.docs[i].data()["idUser"];
        var friend = await FirebaseFirestore.instance
            .collection(_userCollection)
            .where("id", isEqualTo: idFriend)
            .get();
        String name = friend.docs[0].data()["username"];
        String image = friend.docs[0].data()["frontImage"];
        print('a');
        conversationList.add(
          ConversationModel(
            idConversation: idConversation,
            idFriend: idFriend,
            image: image,
            name: name,
          ),
        );
      }
      print(conversationList);
    } catch (e) {
      print(e);
    }
    return conversationList;
  }
}
