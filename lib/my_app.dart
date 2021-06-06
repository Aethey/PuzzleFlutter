import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:photopuzzle/routes/route_name.dart';
import 'package:photopuzzle/widgets/login/login_screen.dart';
import 'package:photopuzzle/widgets/main/main_page.dart';
import 'package:photopuzzle/widgets/puzzle/puzzle_list_page.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  void initApp(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    /// init
    initApp(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Photo Puzzle',
      initialRoute: RouteName.Login,
      routes: {
        RouteName.Login: (context) => LoginScreen(),
        RouteName.Main: (context) => PuzzleListPage(),
        RouteName.Home: (context) => HomePage(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
