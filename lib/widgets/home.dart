import 'dart:convert';
import 'dart:typed_data';

import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photopuzzle/api/cloud_manager.dart';
import 'package:photopuzzle/database/database_helper.dart';
import 'package:photopuzzle/database/puzzle_mock_model.dart';
import 'package:photopuzzle/widgets/puzzle_detail_page.dart';

import 'camera/camera_main_page.dart';


class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomeState();
  }
}

class HomeState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  final ContainerTransitionType _transitionType = ContainerTransitionType.fade;
//  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        Image.asset(
          'assets/bg/background01.jpg',
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
//          key: scaffoldKey,
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: FutureBuilder<Map<String, dynamic>>(
              future:
                  CloudManager.instance.getPuzzleFromCloud('images', 'user001'),
              builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Container(
                      child: Text('NONE'),
                    );
                    break;
                  case ConnectionState.waiting:
                    return Container(
                      child: Text('WAITING'),
                    );
                    break;
                  case ConnectionState.active:
                    return Container(
                      child: Text('ACTIVE'),
                    );
                    break;
                  case ConnectionState.done:
                    return _buildGridView(snapshot.data);
                    break;

                  default:
                    return Container();
                }
              },
            ),
          ),
        )
      ],
    );
  }

  Widget _buildGridView(Map<String, dynamic> map) {
    return Container(
      color: Colors.transparent,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
        itemBuilder: (context, i) {
          var key = map.keys.elementAt(i);
          var bytes = Base64Decoder().convert(map[key]['b64'] as String);

          return animContainer(bytes);
        },
        itemCount: map.length,
      ),
    );
  }

  void _showMarkedAsDoneSnackBar(bool isMarkedAsDone) {
//    if (isMarkedAsDone ?? false)
//      scaffoldKey.currentState.showSnackBar(const SnackBar(
//        content: Text('Marked as done!'),
//      ));
  }

  Widget animContainer(Uint8List bytes) {
    return _OpenContainerWrapper(
      bytes: bytes,
      transitionType: _transitionType,
      closedBuilder: (BuildContext _, VoidCallback openContainer) {
        return Center(
          child: _SmallerCard(
            openContainer: openContainer,
            subtitle: 'Secondary text',
            bytes: bytes,
          ),
        );
      },
      onClosed: _showMarkedAsDoneSnackBar,
    );
  }

  void testDatabase() async {
    var db = DatabaseHelper();

    var model = PuzzleMockModel(123, 'testtt');

    await db.insertPuzzleMockData(model);
    await db.getPuzzleMockModel(1);
  }

  Future<void> getCamera() async {

    await Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => CameraMainPage(camera: null,),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class _OpenContainerWrapper extends StatelessWidget {
  const _OpenContainerWrapper(
      {this.closedBuilder, this.transitionType, this.onClosed, this.bytes});

  final CloseContainerBuilder closedBuilder;
  final ContainerTransitionType transitionType;
  final ClosedCallback<bool> onClosed;
  final Uint8List bytes;

  @override
  Widget build(BuildContext context) {
    return OpenContainer<bool>(
      closedColor: Colors.transparent,
      openColor: Colors.white,
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      transitionDuration: Duration(milliseconds: 300),
      transitionType: transitionType,
      openBuilder: (BuildContext context, VoidCallback _) {
        return DetailsPage(
          bytes: bytes,
        );
      },
      onClosed: onClosed,
      tappable: false,
      closedBuilder: closedBuilder,
    );
  }
}

class _SmallerCard extends StatelessWidget {
  const _SmallerCard({this.openContainer, this.subtitle, this.bytes});

  final VoidCallback openContainer;
  final String subtitle;
  final Uint8List bytes;

  @override
  Widget build(BuildContext context) {
    return Container(
//      color: Colors.transparent,
      child: _InkWellOverlay(
        openContainer: openContainer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: [
                Container(
//                  decoration: new BoxDecoration(
//                    //背景
//                    color: Colors.transparent,
//                    //设置四周圆角 角度
//                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                    //设置四周边框
//                    border: new Border.all(width: 1, color: Colors.transparent),
//                  ),

                  width: MediaQuery.of(context).size.width / 2 - 5,
//                  margin:
//                      EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                  height: MediaQuery.of(context).size.width / 2 - 5,
//              color: Colors.transparent,
                  child: Image.memory(
                    bytes,
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(40.0),
                              topRight: const Radius.circular(40.0),
                              bottomLeft: const Radius.circular(10.0),
                              bottomRight: const Radius.circular(10.0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange,
                                blurRadius: 5.0,
                              ),
                            ]),
                        margin: EdgeInsets.only(left: 2, top: 2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.width / 6,
                              width: MediaQuery.of(context).size.width / 6,
                              child: CircleAvatar(
                                radius: 60,
                                backgroundImage:
                                    AssetImage('assets/bg/waifu.jpg'),
                              ),
                            ),
                            Text('Made By'),
                            Text('UserName'),
                          ],
                        ),
                      ),
                      Container(
                        child: Text('asdasdasdasd'),
                      )
                    ],
                  ),
                )
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Title',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InkWellOverlay extends StatelessWidget {
  const _InkWellOverlay({
    this.openContainer,
    this.width,
    this.height,
    this.child,
  });

  final VoidCallback openContainer;
  final double width;
  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: SizedBox(
        height: height,
        width: width,
        child: InkWell(
          onTap: openContainer,
          child: child,
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(size.width, size.height, size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
