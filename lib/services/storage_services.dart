import 'package:get_storage/get_storage.dart';

class StorageServices {
  GetStorage? _getStorage;

  static StorageServices? _services;

  StorageServices._() {
    _getStorage = GetStorage();
  }

  static StorageServices getInstance() => _services ??= StorageServices._();

  saveData({required KeyStorage key, required String value}) async {
    await _getStorage!.write(key.key!, value);
  }

  String? loadData({required KeyStorage key}) {
    return _getStorage!.read(key.key!);
  }
  removeAll() {
    _getStorage!.remove(TokenKeyStorage().key!);
    _getStorage!.remove(IdKeyStorage().key!);
    _getStorage!.remove(BackImageKeyStorage().key!);
    _getStorage!.remove(EmailKeyStorage().key!);
    _getStorage!.remove(UsernameKeyStorage().key!);
    _getStorage!.remove(FrontImageKeyStorage().key!);
  }

}

abstract class KeyStorage {
  String? key;
}

class TokenKeyStorage extends KeyStorage {
  TokenKeyStorage() {
    key = "Token";
  }
}

class TypeKeyStorage extends KeyStorage {
  TypeKeyStorage() {
    key = "TYPE";
  }
}
class EmailKeyStorage extends KeyStorage {
  EmailKeyStorage() {
    key = "EMAIL";
  }
}
class UsernameKeyStorage extends KeyStorage {
  UsernameKeyStorage() {
    key = "USERNAME";
  }
}
class FrontImageKeyStorage extends KeyStorage {
  FrontImageKeyStorage() {
    key = "FRONTIMAGE";
  }
}
class BackImageKeyStorage extends KeyStorage {
  BackImageKeyStorage() {
    key = "BACKIMAGE";
  }
}
class IdKeyStorage extends KeyStorage {
  IdKeyStorage() {
    key = "ID";
  }
}
class AddressStorage extends KeyStorage {
  AddressStorage() {
    key = "address";
  }
}
class TokenFirebase extends KeyStorage {
  TokenFirebase() {
    key = "token_firebase";
  }
}
