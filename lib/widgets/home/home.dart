import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photopuzzle/api/cloud_manager.dart';
import 'package:photopuzzle/database/database_helper.dart';
import 'package:photopuzzle/database/puzzle_mock_model.dart';

import '../camera/display_picture_page.dart';
import 'components/item_card.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  final picker = ImagePicker();
  int puzzleTag = 0002;

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
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      // color: Colors.black,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: Image.asset('assets/images/bg_puzzle.jpg').image)),
      child: _streamBuilder(),
    );
  }

  StreamBuilder<QuerySnapshot> _streamBuilder() {
    return StreamBuilder<QuerySnapshot>(
      stream:
          CloudManager.instance.getPuzzleFromCloudRealTime('images', 'user001'),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return _buildNoneWidget(context);
            break;
          case ConnectionState.waiting:
            return _buildWaitingWidget();
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.data == null) {
              return _buildNoneWidget(context);
            } else {
              return _buildGridView(snapshot.data);
            }
            break;

          default:
            return Container();
        }
      },
    );
  }

  Widget _buildWaitingWidget() {
    return Container(
      child: Text('WAITING'),
    );
  }

  Widget _buildNoneWidget(BuildContext context) {
    return Container(
      child: Center(
          child: Text(
        'NONE',
        style: Theme.of(context).textTheme.headline2,
      )),
    );
  }

  Widget _buildGridView(QuerySnapshot data) {
    return Container(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
        itemBuilder: (context, i) {
          Uint8List bytes =
              Base64Decoder().convert(data.documents[i]['b64'] as String);
          String id = data.documents[i].documentID;
          return animContainer(bytes, id);
        },
        itemCount: data.documents.length,
      ),
    );
  }

  Widget _buildStaggeredGridView(QuerySnapshot data){
    return Container(
      color: Colors.transparent,
      child: StaggeredGridView.countBuilder(
        crossAxisCount: 4,
        itemCount: data.documents.length,
        itemBuilder: (BuildContext context, int i){
          Uint8List bytes =
          Base64Decoder().convert(data.documents[i]['b64'] as String);
          String id = data.documents[i].documentID;
          return animContainer(bytes, id);
        } ,
        staggeredTileBuilder: (int index) =>
        StaggeredTile.count(2, index.isEven ? 2 : 1),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
      ),
    );
  }

  Widget animContainer(Uint8List bytes, String id) {
    return Center(
      child: ItemCard(
        subtitle: 'Secondary text',
        id: id,
        bytes: bytes,
      ),
    );
  }

  void testDatabase() async {
    DatabaseHelper db = DatabaseHelper();

    PuzzleMockModel model = PuzzleMockModel(123, 'test');
    await db.insertPuzzleMockData(model);
    await db.getPuzzleMockModel(1);
  }

  Future<void> getCamera() async {
    await picker.getImage(source: ImageSource.camera).then((value) => {
          Navigator.push<void>(
            context,
            MaterialPageRoute(
              builder: (context) => DisplayPicturePage(imagePath: value.path),
            ),
          )
        });
  }

  @override
  bool get wantKeepAlive => true;
}

