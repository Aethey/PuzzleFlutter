import 'package:animations/animations.dart';
import 'package:camera/camera.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:photopuzzle/camera/camera_main_page.dart';
import 'package:photopuzzle/firebase/login_page.dart';
import 'package:photopuzzle/home.dart';
import 'package:photopuzzle/route/fade_route.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      color: Colors.yellow,
      home: DefaultTabController(
        length: 4,
        child: new Scaffold(
          body: TabBarView(
            children: [
              LoginPage(),
              HomePage(),
              new Container(
                color: Colors.lightGreen,
              ),
              new Container(
                color: Colors.red,
              ),
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
          bottomNavigationBar: new TabBar(
            tabs: [
              Tab(
                icon: new Icon(Icons.home),
              ),
              Tab(
                icon: new Icon(Icons.rss_feed),
              ),
              Tab(
                icon: new Icon(Icons.perm_identity),
              ),
              Tab(
                icon: new Icon(Icons.settings),
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

    Navigator.push(context, FadeRoute(builder: (context) {
      return CameraMainPage(
        camera: firstCamera,
      );
    }));
  }
}
