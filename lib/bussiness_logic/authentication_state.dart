part of 'authentication_cubit.dart';

class AuthenticationState {
  String chiefOrUser = "";

  AccountModel? account = AccountModel(username: "", email: "", password: "");

  AuthenticationState({required this.chiefOrUser, this.account});

  factory AuthenticationState.initail() {
    return AuthenticationState(chiefOrUser: "");
  }

  AuthenticationState copyWith(String chiefOrUser) {
    return AuthenticationState(chiefOrUser: chiefOrUser);
  }
}

class AuthenticationLoadingState extends AuthenticationState {
  AuthenticationLoadingState() : super(chiefOrUser: "");
}

class AuthenticationErrorState extends AuthenticationState {
  AuthenticationErrorState() : super(chiefOrUser: "");
}

//input in text field
abstract class TypeTextField {}

class LoginObscureTextField extends TypeTextField {}

class FirstRegisterObscureTextField extends TypeTextField {}

class SecondRegisterObscureTextField extends TypeTextField {}

class EmailTextField extends TypeTextField {}

class SimpleTextField extends TypeTextField {}

class NoneObscureTextField extends TypeTextField {}

// input data from textField
abstract class TextFieldData {}

class UsernameTextFieldData extends TextFieldData {}

class EmailTextFieldData extends TextFieldData {}

class PasswordTextFieldData extends TextFieldData {}

class AddressTextFieldData extends TextFieldData {}
