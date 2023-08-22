import 'package:rest_app/data/models/account_model.dart';
import 'package:rest_app/data/web_services/authentication/authontication_web_services.dart';
import 'package:rest_app/data/web_services/authentication/state_Account.dart';

class AuthenticationRepository {
  final Authentication _authentication = Authentication();

  Future<ResponseMessageData> signUpWithEmail(
      {required AccountModel accountModel}) async {
    return await _authentication.signUpWithEmail(accountModel: accountModel);
  }

  Future<ResponseMessageData> loginWithEmail(
      {required AccountModel accountModel}) async {
    return await _authentication.signInWithEmail(accountModel: accountModel);
  }

  Future<AccountModel> getDataProfile({String? idRestaurant}) async {
    return await _authentication.getDataProfile(idRestaurant:idRestaurant);
  }

  Future<ResponseMessageData> updateNameAndAddress(
      {required String name,
      required String address,
      required bool isNameAndAddress}) {
    return _authentication.updateNameAndAddress(
        name: name, address: address, isNameAndAddress: isNameAndAddress);
  }

  Future<ResponseMessageData> updateImageProfile(
      {required String path, required ImageUpdateType imageUpdateType}) {
    return _authentication.updateImageProfile(
        path: path, imageUpdateType: imageUpdateType);
  }

  Future<ResponseMessageData> deleteImageProfile(
      {required ImageUpdateType imageUpdateType}) {
    return _authentication.deleteImageProfile(imageUpdateType: imageUpdateType);
  }

  Future<void> signOut() {
    return _authentication.signOut();
  }

  Future<void> deleteAccount() async {
    return await _authentication.deleteAccount();
  }

  Future<bool> isFoundAccount() async {
    return await _authentication.isFound();
  }
}
