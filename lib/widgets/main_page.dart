import 'package:camera/camera.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:photopuzzle/routes/fade_route.dart';
import 'package:photopuzzle/widgets/user_info_page.dart';

import 'camera/camera_main_page.dart';
import 'home.dart';
import 'login_page.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      color: Colors.yellow,
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          body: TabBarView(
            children: [
              LoginPage(),
              HomePage(),
              Container(
                color: Colors.lightGreen,
              ),
              UserInfoPage(),
            ],
          ),
          floatingActionButton: FabCircularMenu(
              ringDiameter: MediaQuery.of(context).size.width * 2 / 3,
              ringColor: Colors.transparent,
              fabOpenColor: Colors.white,
              fabCloseColor: Colors.blueGrey,
              fabOpenIcon: Icon(Icons.menu),
              fabCloseIcon: Icon(
                Icons.clear,
              ),
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.camera),
                    onPressed: () {
                      getCamera(context);
                    }),
                IconButton(
                    icon: Icon(Icons.photo_library),
                    onPressed: () {
                      print('Favorite');
                    }),
              ]),
          bottomNavigationBar: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.home),
              ),
              Tab(
                icon: Icon(Icons.rss_feed),
              ),
              Tab(
                icon: Icon(Icons.perm_identity),
              ),
              Tab(
                icon: Icon(Icons.settings),
              )
            ],
            labelColor: Colors.yellow,
            unselectedLabelColor: Colors.blue,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.all(5.0),
            indicatorColor: Colors.red,
          ),
          backgroundColor: Colors.black,
        ),
      ),
    );
  }

  Future<void> getCamera(BuildContext context) async {
    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();
    // Get a specific camera from the list of available cameras.
    final firstCamera = cameras.first;

    await Navigator.push<void>(context, FadeRoute(builder: (context) {
      return CameraMainPage(
        camera: firstCamera,
      );
    }));
  }
}
