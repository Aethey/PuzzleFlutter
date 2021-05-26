import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:photopuzzle/common/route_name.dart';
import 'package:photopuzzle/firebase/login_page.dart';
import 'package:photopuzzle/home.dart';
import 'package:photopuzzle/main_page.dart';
import 'package:photopuzzle/provider/model/camera_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => CameraProviderModel(),
      )
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  void initApp(BuildContext context) {
    /// initCamera
    Provider.of<CameraProviderModel>(context, listen: false).initCamera();
  }

  @override
  Widget build(BuildContext context) {
    /// init
    initApp(context);
    return FlutterEasyLoading(
      child: MaterialApp(
        title: 'Photo Puzzle',
        initialRoute: RouteName.Main,
        routes: {
//          RouteName.Home: (context) => HomePage(),
          RouteName.Login: (context) => LoginPage(),
          RouteName.Main: (context) => MainPage(),
        },
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
//      home: FirebaseTestPage(
//        title: 'Firebase Analytics Demo',
//        analytics: analytics,
//        observer: observer,
//      ),
      ),
    );
  }
}
