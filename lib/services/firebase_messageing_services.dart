import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rest_app/data/notification_id/load_token.dart';
import 'package:rest_app/services/CustomNotification.dart';
import 'package:rest_app/services/storage_services.dart';

class FirebaseMessagingServices {
  final String _serverKey =
      "AAAA9R4FeNk:APA91bFPrwAHbW6gdKu8h-VlC7k9GRF8gkpgvIRruthrwsvLngWNMqhE379X2bHaDqC6uk_Grr0FYf6O4M7ATAgGvOHvEEVtiJnR4baiAXJrzTj7H9PYsvi079dFgwRz_k1L8CyCwnvK";

  static FirebaseMessagingServices? _firebaseMessagingServices;

  FirebaseMessagingServices._();

  static FirebaseMessagingServices instance(){
    _firebaseMessagingServices = _firebaseMessagingServices ??= FirebaseMessagingServices._();
    return _firebaseMessagingServices!;
  }

  requestPermission() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  Future<String> getTokenFirebaseMessaging() async{
    String tokenFirebaseMessaging = "";
    await FirebaseMessaging.instance.getToken().then((token) {
      tokenFirebaseMessaging = token!;
    });
    return tokenFirebaseMessaging;
  }

  eventNotification() {
    FirebaseMessaging.onMessage.listen((event)async {
      await NotificationService().showNotification(1, event.notification!.title!, event.notification!.body!, 5);
    });

    // FirebaseMessaging.onMessageOpenedApp.listen((event) {
    //   Navigator.of(context).pushNamed(chatScreen);
    // });

    // var message = FirebaseMessaging.instance.getInitialMessage();
    // if(message !=null){
    //   moveScreen
    // }
  }

  sendNotification({required String title,required String body , required LoadToken loadToken}) async {

    await Dio().post(
      "https://fcm.googleapis.com/fcm/send",
      data: {
        'notification':{
          'body':body,
          'title':title,
        },
        'priority':'high',
        'data':{
          'click_action':'FLUTTER_NOTIFICATION_CLICK',
          "id":StorageServices.getInstance().loadData(key: TokenFirebase()),
        },
        "to":await loadToken.getToken(),
      },
      options: Options(
        headers: {
          'Content-Type':'application/json',
          'Authorization':'key= $_serverKey'
        },
      ),
    );
  }
}
