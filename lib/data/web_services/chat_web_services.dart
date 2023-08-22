import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rest_app/data/models/message_model.dart';
import 'package:rest_app/data/notification_id/load_token.dart';
import 'package:rest_app/services/firebase_messageing_services.dart';
import 'package:rest_app/services/storage_services.dart';

class ChatWebServices {
  final String messageCollection = "Chat";
  final String idSender = "idSender";
  final String message = "message";
  final String idConversation = "idConversation";
  final String date = "date";

  sendMessage({required MessageModel messageModel}) async {
    await FirebaseFirestore.instance.collection(messageCollection).add({
      idConversation: messageModel.idConversation,
      date: Timestamp.now(),
      idSender: StorageServices.getInstance().loadData(key: TokenKeyStorage()),
      message: messageModel.message,
    });
    print((await FirebaseFirestore.instance
            .collection("User")
            .where("id", isEqualTo: messageModel.idSended)
            .get())
        .docs[0]
        .data()["username"]);

    final conversation = await FirebaseFirestore.instance
        .collection("Conversation")
        .doc(messageModel.idConversation)
        .get();
    print(conversation.data()!["idRestaurant"] == messageModel.idSended);
    print(conversation.data()!["idRestaurant"] == messageModel.idSended
        ? conversation.data()!["idUser"]
        : conversation.data()!["idRestaurant"]);
    print(LoadToken(id: conversation.data()!["idRestaurant"] == messageModel.idSended
        ? conversation.data()!["idUser"]
        : conversation.data()!["idRestaurant"]).getToken());
    FirebaseMessagingServices.instance().sendNotification(
      title: (await FirebaseFirestore.instance
              .collection("User")
              .where("id", isEqualTo: messageModel.idSended)
              .get())
          .docs[0]
          .data()["username"],
      body: messageModel.message,
      loadToken: LoadToken(id: conversation.data()!["idRestaurant"] == messageModel.idSended
          ? conversation.data()!["idUser"]
          : conversation.data()!["idRestaurant"]),
    );
  }

  Stream<QuerySnapshot> getMessages({required MessageModel messageModel}) {
    return FirebaseFirestore.instance
        .collection(messageCollection)
        .where(
          idConversation,
          isEqualTo: messageModel.idConversation,
        )
        .orderBy(date, descending: true)
        .limit(100)
        .snapshots();
  }
}
