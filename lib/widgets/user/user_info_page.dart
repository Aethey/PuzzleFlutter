import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photopuzzle/common/constants.dart';

class UserInfoPage extends StatefulWidget {
  final User? user;

  const UserInfoPage({Key? key, this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() => UserInfoState(
        user,
      );
}

class UserInfoState extends State<UserInfoPage>
    with AutomaticKeepAliveClientMixin {
  final User? user;

  static List<String> mockSetTextList = [
    'DarkMode',
    'DataBase',
    'X',
    'X',
    'X',
    'X',
    'X',
    'X',
    'X'
  ];

  UserInfoState(this.user);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          _buildInfoWidget(context, size),
          _buildGridWidget(context),
        ],
      ),
    );
  }

  Widget _buildInfoWidget(BuildContext context, Size size) {
    return Container(
      width: size.width,
      height: size.height / 5,
      child: Image.asset(
        'assets/images/banner.jpg',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildGridWidget(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 4 / 5,
      height: MediaQuery.of(context).size.height / 2,
      alignment: Alignment.center,
      child: GridView.builder(
          itemCount: 9,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 5),
          itemBuilder: (context, index) {
            return Container(
              color: Colors.black12,
              child: Center(
                child: Text(mockSetTextList[index]),
              ),
            );
          }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
