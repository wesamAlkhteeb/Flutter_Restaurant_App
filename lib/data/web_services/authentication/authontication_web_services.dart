import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rest_app/data/models/account_model.dart';
import 'package:rest_app/data/web_services/authentication/state_Account.dart';
import 'package:rest_app/services/firebase_messageing_services.dart';
import 'package:rest_app/services/storage_services.dart';

class Authentication {
  Future<ResponseMessageData> signInWithEmail(
      {required AccountModel accountModel}) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: accountModel.email.trim(),
          password: accountModel.password.trim());
      await FirebaseFirestore.instance
          .collection("User")
          .where("id", isEqualTo: credential.user!.uid)
          .get()
          .then((value) async {
        await StorageServices.getInstance().saveData(
            key: TypeKeyStorage(), value: value.docs[0]["typeOfAccount"]);
        await StorageServices.getInstance()
            .saveData(key: TokenKeyStorage(), value: credential.user!.uid);
        await StorageServices.getInstance().saveData(
            key: UsernameKeyStorage(), value: value.docs[0]["username"]);
        await StorageServices.getInstance()
            .saveData(key: EmailKeyStorage(), value: value.docs[0]["email"]);
        await StorageServices.getInstance().saveData(
            key: FrontImageKeyStorage(), value: value.docs[0]["frontImage"]);
        await StorageServices.getInstance().saveData(
            key: BackImageKeyStorage(), value: value.docs[0]["backImage"]);
        await StorageServices.getInstance()
            .saveData(key: IdKeyStorage(), value: value.docs[0].id);
        await StorageServices.getInstance()
            .saveData(key: AddressStorage(), value: value.docs[0]["address"]);

        String tokenFirebase = await FirebaseMessagingServices.instance().getTokenFirebaseMessaging();
        FirebaseFirestore.instance
            .collection("User")
            .doc(value.docs[0].id)
            .update({
          "tokenNotification": tokenFirebase,
        });
        await StorageServices.getInstance()
            .saveData(key: TokenFirebase(), value: tokenFirebase );
      });

      return ResponseMessageData(
          "login has successfully✔", StateResponse.successfully);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return ResponseMessageData(
            "No user found for that email. ❌", StateResponse.error);
      } else if (e.code == 'wrong-password') {
        return ResponseMessageData(
            "Wrong password provided for that user. ❌", StateResponse.error);
      }
    } catch (e) {
      if (e
          .toString()
          .contains("Invalid value: Valid value range is empty: 0")) {
        return ResponseMessageData(
            "No user found for that email. ❌", StateResponse.error);
      } else if (e.toString().contains("Account is login")) {
        return ResponseMessageData(
            "account is login from another person. ❌", StateResponse.error);
      }
    }
    return ResponseMessageData("error in connecting ❌", StateResponse.error);
  }

  Future<ResponseMessageData> signUpWithEmail(
      {required AccountModel accountModel}) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: accountModel.email.trim(),
        password: accountModel.password.trim(),
      );
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();

      await FirebaseFirestore.instance.collection("User").add({
        "email": accountModel.email.trim(),
        "typeOfAccount": accountModel.typeAccount!.type,
        "id": credential.user!.uid,
        "username": accountModel.username.trim(),
        "frontImage": "",
        "backImage": "",
        "Star": 1.0,
        "address": accountModel.address,
        "tokenNotification": "",
      });
      return ResponseMessageData(
          "Register Has Successfully. please check your email for validate ✔",
          StateResponse.successfully);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return ResponseMessageData(
            "The password provided is too weak. ❌", StateResponse.error);
      } else if (e.code == 'email-already-in-use') {
        return ResponseMessageData(
            "The account already exists for that email. ❌",
            StateResponse.error);
      }
    }
    return ResponseMessageData("error in connecting ❌", StateResponse.error);
  }

  signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  getDataProfile({String? idRestaurant}) async {
    AccountModel accountModel =
        AccountModel(username: "", email: "", password: "");
    try {
      await FirebaseFirestore.instance
          .collection("User")
          .where(
            "id",
            isEqualTo: idRestaurant ??
                StorageServices.getInstance().loadData(key: TokenKeyStorage())!,
          )
          .get()
          .then(
        (value) {
          if (value.docs[0].exists) {
            accountModel.username = value.docs[0].data()["username"];
            accountModel.frontImage = value.docs[0].data()["frontImage"];
            accountModel.backImage = value.docs[0].data()["backImage"];
            accountModel.email = value.docs[0].data()["email"];
            accountModel.address = value.docs[0].data()["address"];
            accountModel.id = value.docs[0].data()["id"];
            accountModel.star = value.docs[0].data()["Star"];
            StorageServices.getInstance().saveData(
                key: UsernameKeyStorage(), value: accountModel.username);
            StorageServices.getInstance().saveData(
                key: FrontImageKeyStorage(), value: accountModel.frontImage!);
          }
        },
      );
      return accountModel;
    } catch (e) {
      print(e);
      return AccountModel(username: "", email: "", password: "");
    }
  }

  Future<ResponseMessageData> updateNameAndAddress(
      {required String name,
      required String address,
      required bool isNameAndAddress}) async {
    try {
      if (isNameAndAddress) {
        await FirebaseFirestore.instance
            .collection("User")
            .doc(StorageServices.getInstance().loadData(key: IdKeyStorage()))
            .update({"username": name, "address": address});
      } else {
        await FirebaseFirestore.instance
            .collection("User")
            .doc(StorageServices.getInstance().loadData(key: IdKeyStorage()))
            .update({"address": address});
      }
      await StorageServices.getInstance()
          .saveData(key: AddressStorage(), value: address);
      if (isNameAndAddress) {
        await StorageServices.getInstance()
            .saveData(key: UsernameKeyStorage(), value: name);
      }
      return ResponseMessageData(
          "update name has been successfully", StateResponse.successfully);
    } catch (e) {
      return ResponseMessageData("error in update name", StateResponse.error);
    }
  }

  Future<ResponseMessageData> updateImageProfile(
      {required String path, required ImageUpdateType imageUpdateType}) async {
    try {
      File file = File(path);
      String basename = (path.split("/").last).split(".").first;
      final ref = FirebaseStorage.instance
          .ref("Users/$basename${Random().nextInt(10000)}");
      await ref.putFile(file);

      String pathForDelete = (await FirebaseFirestore.instance
                  .collection("User")
                  .where("id",
                      isEqualTo: StorageServices.getInstance()
                          .loadData(key: TokenKeyStorage()))
                  .get())
              .docs[0]
          [imageUpdateType is BackImageUpdateType ? "backImage" : "frontImage"];

      await FirebaseFirestore.instance
          .collection("User")
          .doc(StorageServices.getInstance().loadData(key: IdKeyStorage()))
          .update({
        imageUpdateType is BackImageUpdateType ? "backImage" : "frontImage":
            await ref.getDownloadURL()
      });

      if (pathForDelete != "") {
        await FirebaseStorage.instance.refFromURL(pathForDelete).delete();
      }

      return ResponseMessageData(
          "update name has been successfully", StateResponse.successfully);
    } catch (e) {
      return ResponseMessageData("error in update name", StateResponse.error);
    }
  }

  Future<ResponseMessageData> deleteImageProfile(
      {required ImageUpdateType imageUpdateType}) async {
    try {
      String pathForDelete = (await FirebaseFirestore.instance
                  .collection("User")
                  .where("id",
                      isEqualTo: StorageServices.getInstance()
                          .loadData(key: TokenKeyStorage()))
                  .get())
              .docs[0]
          [imageUpdateType is BackImageUpdateType ? "backImage" : "frontImage"];

      await FirebaseFirestore.instance
          .collection("User")
          .doc(StorageServices.getInstance().loadData(key: IdKeyStorage()))
          .update({
        imageUpdateType is BackImageUpdateType ? "backImage" : "frontImage": ""
      });

      if (pathForDelete != "") {
        await FirebaseStorage.instance.refFromURL(pathForDelete).delete();
      }
      return ResponseMessageData(
          "update name has been successfully", StateResponse.successfully);
    } catch (e) {
      return ResponseMessageData("error in update name", StateResponse.error);
    }
  }

  Future<void> deleteAccount() async {
    try {
      await _deleteOrder();
      await _deleteFavorite();
      await _deleteAllStar();
      if (StorageServices.getInstance().loadData(key: TypeKeyStorage()) !=
          "User") {
        await _deleteAllMeal();
      }
      await _deleteChats();
      await _deleteAccountUser();
    } catch (e) {
      throw Exception(e);
    }
  }

  _deleteFavorite() async {
    final allStar = await FirebaseFirestore.instance
        .collection("favorite")
        .where(
          StorageServices.getInstance().loadData(key: TypeKeyStorage()) !=
                  "User"
              ? "id_restaurant"
              : "id_user",
          isEqualTo:
              StorageServices.getInstance().loadData(key: TokenKeyStorage())!,
        )
        .get();

    for (int i = 0; i < allStar.docs.length; i++) {
      await FirebaseFirestore.instance
          .collection("favorite")
          .doc(allStar.docs[i].id)
          .delete();
    }
  }

  _deleteOrder() async {
    try {
      String idUser =
          StorageServices.getInstance().loadData(key: TokenKeyStorage())!;
      String idDelete =
          StorageServices.getInstance().loadData(key: TypeKeyStorage())! ==
                  "User"
              ? "id_user"
              : "id_restaurant";
      final order = await FirebaseFirestore.instance
          .collection("Order")
          .where(
            idDelete,
            isEqualTo: idUser,
          )
          .get();
      for (int i = 0; i < order.docs.length; i++) {
        print(order.docs[i].id);
        await FirebaseFirestore.instance
            .collection("Order")
            .doc(order.docs[i].id)
            .delete();

        final orderDetail = await FirebaseFirestore.instance
            .collection("DetailOrder")
            .where("id_order", isEqualTo: order.docs[i].id)
            .get();
        for (int i = 0; i < orderDetail.docs.length; i++) {
          await FirebaseFirestore.instance
              .collection("DetailOrder")
              .doc(orderDetail.docs[i].id)
              .delete();
        }
      }
    } catch (e) {
      print(e);
    }
  }

  _deleteAllStar() async {
    if (StorageServices.getInstance().loadData(key: TypeKeyStorage()) ==
        "User") {
      final allStarMeal = await FirebaseFirestore.instance
          .collection("StarMeal")
          .where(
            "ID_USER",
            isEqualTo:
                StorageServices.getInstance().loadData(key: TokenKeyStorage())!,
          )
          .get();

      for (int i = 0; i < allStarMeal.docs.length; i++) {
        await FirebaseFirestore.instance
            .collection("StarMeal")
            .doc(allStarMeal.docs[i].id)
            .delete();
      }
    }

    String idDelete =
        StorageServices.getInstance().loadData(key: TypeKeyStorage())! == "User"
            ? "ID_USER"
            : "ID_RESTAURANT";

    final allStarRestaurant = await FirebaseFirestore.instance
        .collection("StarRestaurant")
        .where(
          idDelete,
          isEqualTo:
              StorageServices.getInstance().loadData(key: TokenKeyStorage())!,
        )
        .get();

    for (int i = 0; i < allStarRestaurant.docs.length; i++) {
      await FirebaseFirestore.instance
          .collection("StarRestaurant")
          .doc(allStarRestaurant.docs[i].id)
          .delete();
    }
  }

  _deleteAllMeal() async {
    final allMeal = await FirebaseFirestore.instance
        .collection("Meals")
        .where(
          "id",
          isEqualTo:
              StorageServices.getInstance().loadData(key: TokenKeyStorage())!,
        )
        .get();
    for (int i = 0; i < allMeal.docs.length; i++) {
      await FirebaseStorage.instance
          .refFromURL(allMeal.docs[i].data()["image"])
          .delete();
      FirebaseFirestore.instance
          .collection("Meals")
          .doc(allMeal.docs[i].id)
          .delete();
    }
  }

  _deleteAccountUser() async {
    final user = await FirebaseFirestore.instance
        .collection("User")
        .where(
          "id",
          isEqualTo:
              StorageServices.getInstance().loadData(key: TokenKeyStorage())!,
        )
        .get();
    if (user.docs.isEmpty) {
      return;
    }
    if (user.docs[0].data()["frontImage"] != "") {
      await FirebaseStorage.instance
          .refFromURL(user.docs[0].data()["frontImage"])
          .delete();
    }
    if (user.docs[0].data()["backImage"] != "") {
      await FirebaseStorage.instance
          .refFromURL(user.docs[0].data()["backImage"])
          .delete();
    }
    await FirebaseFirestore.instance
        .collection("User")
        .doc(user.docs[0].id)
        .delete();
    await FirebaseAuth.instance.currentUser?.delete();
  }

  _deleteChats() async {
    String idUser =
        StorageServices.getInstance().loadData(key: TokenKeyStorage())!;
    String idDelete =
        StorageServices.getInstance().loadData(key: TypeKeyStorage())! == "User"
            ? "idUser"
            : "idRestaurant";
    final order = await FirebaseFirestore.instance
        .collection("Conversation")
        .where(
          idDelete,
          isEqualTo: idUser,
        )
        .get();
    for (int i = 0; i < order.docs.length; i++) {
      await FirebaseFirestore.instance
          .collection("Conversation")
          .doc(order.docs[i].id)
          .delete();

      final orderDetail = await FirebaseFirestore.instance
          .collection("Chat")
          .where("idConversation", isEqualTo: order.docs[i].id)
          .get();
      for (int i = 0; i < orderDetail.docs.length; i++) {
        await FirebaseFirestore.instance
            .collection("Chat")
            .doc(orderDetail.docs[i].id)
            .delete();
      }
    }
  }

  Future<bool> isFound() async {
    try {
      var myAccount = await FirebaseFirestore.instance
          .collection("User")
          .where(
            "id",
            isEqualTo:
                StorageServices.getInstance().loadData(key: TokenKeyStorage()),
          )
          .get();
      return myAccount.docs.isNotEmpty ? true : false;
    } catch (e) {
      return false;
    }
  }
}

abstract class ImageUpdateType {}

class FrontImageUpdateType extends ImageUpdateType {}

class BackImageUpdateType extends ImageUpdateType {}
