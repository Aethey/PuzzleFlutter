import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photopuzzle/api/cloud_manager.dart';

class UserInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('USERINFO'),
      ),
      body: Column(
        children: [_buildInfoWidget(context), _buildGridWidget(context),_buildBottomView()],
      ),
    );
  }

  Widget _buildInfoWidget(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 5,
      color: Colors.green,
    );
  }

  Widget _buildGridWidget(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 4 / 5,
      height: MediaQuery.of(context).size.height / 2,
      color: Colors.red,
      alignment: Alignment.center,
      child: GridView.builder(
          itemCount: 9,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 5),
          itemBuilder: (context, index) {
            return Container(
              color: Colors.black12,
              child: Center(
                child: Text('$index'),
              ),
            );
          }),
    );
  }

  Widget _buildBottomView(){
    return Container(
      child: ElevatedButton(
        onPressed: (){
          CloudManager.instance.deleteData('images', 'user001').then((value) =>
          {
            print('delete success')
          });
        },
        child: Text('clear data'),
      ),
    );
  }
}
