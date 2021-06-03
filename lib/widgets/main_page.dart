import 'dart:io';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photopuzzle/widgets/user_info_page.dart';

import 'camera/display_picture_page.dart';
import 'home.dart';

class MainPage extends StatelessWidget {
  final int heroTag;
  final FirebaseUser user;
  final picker = ImagePicker();

  MainPage({Key key, this.heroTag, this.user}) : super(key: key);

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
          floatingActionButton: buildFloatingActionButton(context),
          bottomNavigationBar: buildBottomNavigationBar(),
          backgroundColor: Colors.black,
        ),
      ),
    );
  }

  Container buildBottomNavigationBar() {
    return Container(
      padding: EdgeInsets.only(bottom: 20, top: 10),
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
              icon: Hero(
                  tag: '$heroTag',
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(user != null
                                ? user.photoUrl
                                : 'https://spng.pngfind.com/pngs/s/125-1256363_post-anime-girl-icon-transparent-hd-png-download.png')),
                        color: Colors.black,
                        shape: BoxShape.circle),
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
    );
  }

  FabCircularMenu buildFloatingActionButton(BuildContext context) {
    return FabCircularMenu(
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
                getGallery(context);
              }),
        ]);
  }

  Future<void> getCamera(BuildContext context) async {
    await picker.getImage(source: ImageSource.camera).then((value) {
      cropper(value.path).then((value) {
        if (value != null) {
          Navigator.push<void>(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DisplayPicturePage(imagePath: value.path.toString()),
            ),
          );
        }
      });
    });
  }

  Future<void> getGallery(BuildContext context) async {
    await picker.getImage(source: ImageSource.gallery).then((value) {
      if (value != null) {
        Navigator.push<void>(
          context,
          MaterialPageRoute(
            builder: (context) => DisplayPicturePage(imagePath: value.path),
          ),
        );
      }
      ;
    });
  }

  Future<File> cropper(String path) async {
    return await ImageCropper.cropImage(
        sourcePath: path,
        aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
  }
}
