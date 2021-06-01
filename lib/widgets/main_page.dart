import 'package:camera/camera.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photopuzzle/routes/fade_route.dart';
import 'package:photopuzzle/widgets/user_info_page.dart';

import 'camera/camera_main_page.dart';
import 'home.dart';
import 'login/login_page.dart';

class MainPage extends StatelessWidget {
  final int heroTag;
  final FirebaseUser user;

  const MainPage({Key key, this.heroTag, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      color: Colors.yellow,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          body: TabBarView(
            children: [
              // LoginPage(),
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
          bottomNavigationBar: Container(
            padding: EdgeInsets.only(bottom: 20,top: 10),
            child: Container(
              color: Colors.black,
              child: TabBar(
                tabs: [
                  // Tab(
                  //   icon: Icon(Icons.home),
                  // ),
                  Tab(
                    icon: Icon(Icons.home),
                  ),
                  Tab(
                    icon: Icon(Icons.perm_identity),
                  ),
                  Tab(
                    icon: Hero(tag: '$heroTag', child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  user.photoUrl)),
                          color: Colors.black,
                          shape: BoxShape.circle),

                      // child: Image.asset("assets/images/bg01.jpg",fit: BoxFit.fill,)
                    )),
                  )
                ],
                labelColor: Colors.yellow,
                unselectedLabelColor: Colors.blue,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorPadding: EdgeInsets.all(5.0),
                indicatorColor: Colors.transparent,
              ),
            ),
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
