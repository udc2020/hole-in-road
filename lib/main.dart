import 'package:flutter/material.dart';
import 'package:hole_in_road/models/firebase_controller.dart';
import 'package:hole_in_road/models/notification.dart';
import 'package:hole_in_road/screens/auth/login.dart';

import 'package:hole_in_road/shared/user_provider.dart';
import 'package:hole_in_road/shared/img_provider.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  //? FireBase controller
  FireBaseApi.init();

  //? Awesome Notification inisializer
  NotifocationApi.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ImagProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Hole in Road',
        theme: ThemeData(
          // primarySwatch: Colors.pink,
          primaryColor: Colors.pink,
          primarySwatch: Colors.pink,
          // scaffoldBackgroundColor: Colors.pink,
        ),
        home: const Login(),
      ),
    );
  }
}
