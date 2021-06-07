import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photopuzzle/api/firebase/firebase_storage_manager.dart';

class UserInfoPage extends StatelessWidget {
  List<String> mockSetTextList = [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('USERINFO'),
      ),
      body: Column(
        children: [
          _buildInfoWidget(context),
          _buildGridWidget(context),
          ElevatedButton(
              onPressed: () async {
                    await FirebaseStorageManager().downloadFileExample();
              },
              child: SvgPicture.asset('assets/icons/point.svg'))
        ],
      ),
    );
  }

  Widget _buildInfoWidget(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 5,
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
}
