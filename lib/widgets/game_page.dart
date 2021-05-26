import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photopuzzle/utils/game/game_widget.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class GamePage extends StatelessWidget {
  final Size size;
  final Uint8List bytes;
  final int level;
  GamePage(this.size, this.bytes, this.level);

  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Future<dynamic>.delayed(Duration(milliseconds: 1000))
        .then((dynamic value) => _stopWatchTimer.onExecute.add(StopWatchExecute.start));
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
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 30),
                  height: 100,
                  color: Colors.transparent,
                  child: StreamBuilder<int>(
                    stream: _stopWatchTimer.rawTime,
                    initialData: 0,
                    builder: (context, snap) {
                      final value = snap.data;
                      final displayTime = StopWatchTimer.getDisplayTime(value,
                          milliSecond: false);
                      return Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              displayTime,
                              style: TextStyle(
                                  fontSize: 40,
                                  fontFamily: 'Helvetica',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  height: MediaQuery.of(context).size.height - 300,
                  child: GameWidget(size, bytes, level),
                ),
                Container(
                  height: 200,
                  color: Colors.transparent,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
