import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:photopuzzle/widgets/main/main_page.dart';
import 'package:photopuzzle/widgets/photo/photo_list_page.dart';
import 'package:photopuzzle/widgets/puzzle/puzzle_detail_page.dart';
import 'package:photopuzzle/widgets/puzzle/puzzle_list_page.dart';
import 'package:photopuzzle/widgets/puzzle/puzzle_play_page.dart';
import 'package:photopuzzle/widgets/user/user_info_page.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  final mockObserver = MockNavigatorObserver();
  String widgetTag = 'PuzzleListPage';
  // String widgetTag = "login";

  Widget? getTestWidget(String name) {
    switch (name) {
      case 'PuzzleListPage':
        return MainPage();
      case 'PhotoListPage':
        return PhotoListPage();
      case 'UserInfoPage':
        return UserInfoPage();
      // case 'PuzzlePlayPage':
      //   return PuzzlePlayPage();
      // case 'PuzzleDetailsPage':
      //   return PuzzleDetailsPage(id: '', bytes: null,);
    }

    return Container();
  }
}
