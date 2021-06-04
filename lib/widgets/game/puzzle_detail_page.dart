import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photopuzzle/common/constants.dart';
import 'dart:ui' as ui;
import '../components/my_circle_button.dart';
import 'game_page.dart';
import '../login/components/my_loading_route.dart';

class DetailsPage extends StatelessWidget {
  DetailsPage({this.includeMarkAsDoneButton = true, this.bytes, this.id});

  final bool includeMarkAsDoneButton;
  final Uint8List bytes;
  final String id;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: buildBody(context, size),
    );
  }

  Widget buildBody(BuildContext context, Size size) {
    return Container(
      color: Colors.black.withOpacity(0.8),
      width: size.width,
      child: Column(
        children: <Widget>[
          _buildImage(size),
          Container(
            margin: EdgeInsets.symmetric(horizontal: smallPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildButton(size, context),
                _buildBoard(context, size)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoard(BuildContext context, Size size) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(0xFFcec89f),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 5,
                  offset: Offset(0, 6)),
            ],
            // image: DecorationImage(
            //     fit: BoxFit.cover,
            //     image: Image.asset('assets/images/small_board.jpg').image)
          ),
          margin: EdgeInsets.only(top: size.width / 8),
          width: size.width / 3,
          height: size.width / 3,
          child: ListView(
            padding:
                EdgeInsets.only(top: 0.0, left: verySmallPadding, bottom: 0.0),
            children: [
              _buildRankItem(size),
              _buildRankItem(size),
              _buildRankItem(size),
            ],
          ),
        ),
        Container(
            margin: EdgeInsets.only(
                top: size.width / 10, left: size.width / 3 - 50),
            width: size.width / 12,
            height: size.width / 12,
            child: SvgPicture.asset(
              'assets/icons/bookmark.svg',
              color: Colors.yellow,
            ))
      ],
    );
  }

  Container _buildRankItem(Size size) {
    return Container(
      margin: EdgeInsets.only(top: mediumPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: size.width / 15,
            width: size.width / 15,
            child: CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/bg/waifu.jpg'),
            ),
          ),
          Text(
            '00:00',
            style: TextStyle(
                fontSize: mediumText,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          )
        ],
      ),
    );
  }

  Widget _buildButton(Size size, BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(top: size.width / 8),
        child: Stack(
          children: [
            Container(
              width: size.width / 2,
              height: size.width / 2,
              child: SvgPicture.asset('assets/icons/controller.svg'),
            ),
            Container(
              width: size.width / 2,
              height: size.width / 2,
              padding: EdgeInsets.only(top: size.width / 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MyCircleButton(
                    width: size.width / 6,
                    text: 'X',
                    press: () {
                      Navigator.pop(context, true);
                    },
                  ),
                  MyCircleButton(
                    width: size.width / 6,
                    text: 'O',
                    press: () {
                      startGame(context);
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildImage(Size size) {
    return Hero(
      tag: '$id',
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.skewX(-0.05),
        child: Container(
          height: size.height * 0.6,
          decoration: BoxDecoration(
              border: Border.all(color: Color(0xFFFF0000), width: 0.5),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 5,
                    offset: Offset(10, -6)),
              ]),
          margin: EdgeInsets.only(
              top: veryBigPadding * 2, left: bigPadding, right: bigPadding),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.memory(
              bytes,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> startGame(BuildContext context) async {
    await Navigator.push<void>(
        context,
        MyLoadingRoute<void>(
            duration: Duration(milliseconds: 500),
            builder: (context) =>
                GamePage(MediaQuery.of(context).size, bytes, 3)));
  }
}
