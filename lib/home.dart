import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photopuzzle/camera/camera_main_page.dart';
import 'package:photopuzzle/cloud/cloud_manager.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomeState();
  }
}

class HomeState extends State<HomePage> {
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
            child: FutureBuilder(
              future: CloudManager.instance.getDataFromCloud(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Container();
                    break;
                  case ConnectionState.waiting:
                    return Container();
                    break;
                  case ConnectionState.active:
                    return Container();
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
                  getCamera();
//                  CloudManager.instance.getDataFromCloud();
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
                  child: _buildImageView(map[key]['b64']),
                )
              ],
            ),
          );
        },
        itemCount: map.length,
      ),
    );
  }

  Widget _buildImageView(String b64) {
    Uint8List bytes = Base64Decoder().convert(b64);
    return Container(
      height: 50,
      width: 50,
      child: Image.memory(bytes),
    );
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
