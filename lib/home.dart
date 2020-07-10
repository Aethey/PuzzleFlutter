import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photopuzzle/camera/camera_main_page.dart';
import 'package:photopuzzle/cloud/cloud_manager.dart';
import 'package:photopuzzle/database/database_helper.dart';
import 'package:photopuzzle/database/puzzle_mock_model.dart';
import 'package:photopuzzle/home/grid_item_widget.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomeState();
  }
}

class HomeState extends State<HomePage> {
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
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 2 / 3,
            child: FutureBuilder<Map<String, dynamic>>(
              future:
                  CloudManager.instance.getPuzzleFromCloud('images', 'user001'),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
          Container(
            child: Center(
              child: RaisedButton(
                onPressed: () {
//              getImage();
//                  getCamera();
//                  CloudManager.instance.getDataFromCloud();

                  testDatabase();
                },
                child: Container(
                  color: Colors.orange,
                  height: 100,
                  width: 200,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildGridView(Map<String, dynamic> map) {
    return Container(
      color: Colors.red,
      child: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, i) {
          String key = map.keys.elementAt(i);
          return Container(
            color: Colors.green,
            child: Column(
              children: [
                Text((map[key]['time'] as Timestamp).toDate().day.toString()),
                Container(
                  child: GridItemWidget(
                    b64: map[key]['b64'],
                  ),
                )
              ],
            ),
          );
        },
        itemCount: map.length,
      ),
    );
  }

  void testDatabase() async {
    var db = DatabaseHelper();

    PuzzleMockModel model = PuzzleMockModel(123, 'testtt');

    await db.insertPUzzleMockData(model);
    db.getPuzzleMockModel(1);
  }

  Future<void> getCamera() async {
    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();
    // Get a specific camera from the list of available cameras.
    final firstCamera = cameras.first;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraMainPage(camera: firstCamera),
      ),
    );
  }
}
