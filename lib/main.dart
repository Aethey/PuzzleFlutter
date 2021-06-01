import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:photopuzzle/routes/route_name.dart';
import 'package:photopuzzle/widgets/login/login_page.dart';
import 'package:photopuzzle/widgets/login/login_screen.dart';
import 'package:photopuzzle/widgets/main_page.dart';
import 'package:photopuzzle/states/provider/model/camera_provider.dart';
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Photo Puzzle',
      initialRoute: RouteName.Login,
      routes: {
//          RouteName.Home: (context) => HomePage(),
        RouteName.Login: (context) => LoginScreen(),
        RouteName.Main: (context) => MainPage(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
