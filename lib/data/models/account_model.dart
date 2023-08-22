import 'package:firebase_auth/firebase_auth.dart';

abstract class TypeAccount {
  String? type;
}

class ChiefAccount extends TypeAccount {
  ChiefAccount() {
    type = "Chief";
  }
}

class UserAccount extends TypeAccount {
  UserAccount() {
    type = "User";
  }
}

class AccountModel {
  String username, email, password;
  TypeAccount? typeAccount;
  double? star;
  String? backImage, frontImage , address , id;

  AccountModel({
    required this.username,
    required this.email,
    required this.password,
    this.star,
    this.backImage,
    this.frontImage,
    this.typeAccount,
    this.address,
  });


  @override
  String toString() {
    return 'AccountModel{username: $username, email: $email, password: $password, typeAccount: $typeAccount, star: $star, backImage: $backImage, frontImage: $frontImage, address: $address}';
  }

  clear() {
    username = "";
    email = "";
    password = "";
    typeAccount = null;
    address = "";
  }
}
