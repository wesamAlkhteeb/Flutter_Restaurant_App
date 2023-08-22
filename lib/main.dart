
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rest_app/app_router.dart';
import 'package:rest_app/bussiness_logic/theme_controller_cubit.dart';
import 'package:rest_app/constant/strings.dart';
import 'package:rest_app/services/CustomNotification.dart';
import 'package:rest_app/services/firebase_messageing_services.dart';
import 'package:rest_app/services/storage_services.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  FirebaseMessagingServices.instance().requestPermission();
  NotificationService().initNotification();


  FirebaseMessagingServices.instance().eventNotification();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  AppRouter appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeControllerCubit>(
      create: (_) => ThemeControllerCubit(),
      child: BlocBuilder<ThemeControllerCubit, ThemeControllerState>(
        builder: (ctx, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            onGenerateRoute: appRouter.generateRoute,
            initialRoute: StorageServices.getInstance().loadData(key:TokenKeyStorage())== null?loginScreen:mainScreen,
            theme: state.themeData,
            builder: EasyLoading.init(),
          );
        },
      ),
    );
  }
}