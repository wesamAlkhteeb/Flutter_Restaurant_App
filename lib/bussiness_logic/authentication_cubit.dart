import 'package:bloc/bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rest_app/data/models/account_model.dart';
import 'package:rest_app/data/repository/authentication_repository.dart';
import 'package:rest_app/data/web_services/authentication/authontication_web_services.dart';
import 'package:rest_app/data/web_services/authentication/state_Account.dart';
import 'package:rest_app/services/storage_services.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationRepository authenticationRepository =
      AuthenticationRepository();

  AuthenticationCubit()
      : super(AuthenticationState(
          chiefOrUser: "",
        ));

  bool requestProfile = false;

  Future getDataProfile({String? idRestaurant}) async {
    emit(AuthenticationLoadingState());
    await authenticationRepository.getDataProfile(idRestaurant:idRestaurant).then((value) {
      emit(AuthenticationState(chiefOrUser: "", account: value));
      requestProfile = true;
    }).onError((error, stackTrace) {
      emit(AuthenticationErrorState());
    });
  }

  Future<ResponseMessageData> signUpWithEmail() async {
    emit(AuthenticationState(chiefOrUser: "", account: accountModel));
    return await authenticationRepository.signUpWithEmail(
        accountModel: state.account!);
  }

  Future<ResponseMessageData> updateImageProfile(
      {required String path, required ImageUpdateType imageUpdateType}) async {
    emit(AuthenticationLoadingState());
    ResponseMessageData responseAuthentication =
        ResponseMessageData("", StateResponse.error);
    await authenticationRepository
        .updateImageProfile(path: path, imageUpdateType: imageUpdateType)
        .then((value) {
      responseAuthentication = value;
    }).onError((error, stackTrace) {
      emit(AuthenticationErrorState());
      responseAuthentication.message = error.toString();
    });
    getDataProfile();
    return responseAuthentication;
  }

  Future<ResponseMessageData> deleteImageProfile(
      {required ImageUpdateType imageUpdateType}) async {
    emit(AuthenticationLoadingState());
    ResponseMessageData responseAuthentication =
    ResponseMessageData("", StateResponse.error);
    await authenticationRepository
        .deleteImageProfile(imageUpdateType: imageUpdateType)
        .then((value) {
      responseAuthentication = value;
    }).onError((error, stackTrace) {
      emit(AuthenticationErrorState());
      responseAuthentication.message = error.toString();
    });
    getDataProfile();
    return responseAuthentication;
  }


  Future<ResponseMessageData> loginWithEmail() async {
    emit(AuthenticationState(chiefOrUser: "", account: accountModel));
    return await authenticationRepository.loginWithEmail(
        accountModel: state.account!);
  }

  updateNameAndAddress(bool isNameAndAddress) async {
    return await authenticationRepository.updateNameAndAddress(
        name: accountModel.username , address :accountModel.address! , isNameAndAddress: isNameAndAddress);
  }

  signOut(){
    return authenticationRepository.signOut();
  }

  bool isObscureLogin = true,
      isObscureSignInFirst = true,
      isObscureSignInSecond = true;

  changeObscureLogin(TypeTextField obscureType) {
    if (obscureType is LoginObscureTextField) {
      isObscureLogin = !isObscureLogin;
    } else if (obscureType is FirstRegisterObscureTextField) {
      isObscureSignInFirst = !isObscureSignInFirst;
    } else if (obscureType is SecondRegisterObscureTextField) {
      isObscureSignInSecond = !isObscureSignInSecond;
    }

    AuthenticationState authenticationState =
        AuthenticationState(chiefOrUser: "");
    emit(authenticationState);
  }

  AccountModel accountModel =
      AccountModel(username: "", email: "", password: "");

  changeDataInput(TextFieldData textFieldData, String data) {
    if (textFieldData is UsernameTextFieldData) {
      accountModel.username = data;
    } else if (textFieldData is EmailTextFieldData) {
      accountModel.email = data;
    } else if (textFieldData is PasswordTextFieldData) {
      accountModel.password = data;
    }else if (textFieldData is AddressTextFieldData){
      accountModel.address = data;
    }
  }

  //ratio

  changeTypeAccount(TypeAccount typeAccount) {
    if (!isClosed) {
      accountModel.typeAccount = typeAccount;
      emit(state.copyWith(typeAccount.type!));
    }
  }

  clearData() {
    state.account!.typeAccount = null;
    state.account!.password = "";
    state.account!.username = "";
    state.account!.email = "";
  }

  String? validUserName(){
    if (accountModel.username == null || accountModel.username.isEmpty) {
      return "please enter your name.";
    }
    if (accountModel.username.length < 4) {
      return "name is short";
    }
    if (accountModel.username.length > 20) {
      return "name is long";
    }
    return null;
  }
  String? validAddress(){
    if (accountModel.address == null || accountModel.address!.isEmpty) {
      return "please enter your address.";
    }
    if (accountModel.address!.length < 4) {
      return "address is short";
    }
    if (accountModel.address!.length > 20) {
      return "address is long";
    }
    return null;
  }

  deleteAccount()async{
    return await authenticationRepository.deleteAccount();
  }

  isFoundAccount()async{
    bool a = await authenticationRepository.isFoundAccount();
    if(!a){
      StorageServices.getInstance().removeAll();
    }
  }
}
