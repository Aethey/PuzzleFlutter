import 'dart:io';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photopuzzle/common/constants.dart';
import 'package:photopuzzle/widgets/game/display_picture_page.dart';
import 'package:photopuzzle/widgets/photo/photo_list_page.dart';
import 'package:photopuzzle/widgets/puzzle/puzzle_list_page.dart';
import 'package:photopuzzle/widgets/user/user_info_page.dart';

/// main page
class MainPage extends StatelessWidget {
  final int? heroTag;
  final User? user;
  final picker = ImagePicker();

  /// use for switch FabCircularMenu open/close
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();

  MainPage({Key? key, this.heroTag, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          body: TabBarView(
            children: [
              PuzzleListPage(),
              PhotoListPage(),
              UserInfoPage(user: user),
            ],
          ),
          floatingActionButton: buildFloatingActionButton(context, size),
          bottomNavigationBar: buildBottomNavigationBar(),
          backgroundColor: Colors.white.withOpacity(0.8),
        ),
      ),
    );
  }

  Widget buildBottomNavigationBar() {
    return Container(
      padding: EdgeInsets.only(bottom: mediumPadding, top: smallPadding),
      child: Container(
        // color: Colors.black,
        child: TabBar(
          tabs: [
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
                    height: mediumSize,
                    width: mediumSize,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(user != null
                                ? user!.photoURL!
                                : 'https://spng.pngfind.com/pngs/s/125-1256363_post-anime-girl-icon-transparent-hd-png-download.png')),
                        color: Colors.black,
                        shape: BoxShape.circle),
                  )),
            )
          ],
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.black,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorPadding: EdgeInsets.all(verySmallPadding),
          indicatorColor: Colors.transparent,
        ),
      ),
    );
  }

  /// a button with a menu {take photo || use library}
  FabCircularMenu buildFloatingActionButton(BuildContext context, Size size) {
    return FabCircularMenu(
        key: fabKey,
        ringDiameter: size.width * 2 / 3,
        ringColor: Colors.transparent,
        fabOpenColor: Colors.grey,
        fabCloseColor: Colors.blueGrey,
        fabOpenIcon: Icon(Icons.camera_alt),
        fabCloseIcon: Icon(
          Icons.clear,
        ),
        children: <Widget>[
          IconButton(
              icon: Icon(
                Icons.camera,
                color: Colors.white,
              ),
              onPressed: () {
                if (fabKey.currentState!.isOpen) {
                  fabKey.currentState!.close();
                }
                getCamera(context);
              }),
          IconButton(
              icon: Icon(
                Icons.photo_library,
                color: Colors.white,
              ),
              onPressed: () {
                if (fabKey.currentState!.isOpen) {
                  fabKey.currentState!.close();
                }
                getGallery(context);
              }),
        ]);
  }

  /// go to camera,need permission
  Future<void> getCamera(BuildContext context) async {
    await picker.getImage(source: ImageSource.camera).then((value) {
      cropper(value!.path).then((value) {
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

  /// go to library,need permission
  Future<void> getGallery(BuildContext context) async {
    await picker.getImage(source: ImageSource.gallery).then((value) {
      if (value != null) {
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
      }
    });
  }

  /// get image from camera or library,then crop it for use
  Future<File?> cropper(String path) async {
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
