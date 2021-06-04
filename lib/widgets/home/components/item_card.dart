import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photopuzzle/common/constants.dart';
import 'package:photopuzzle/widgets/login/components/my_loading_route.dart';

import '../../game/puzzle_detail_page.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({this.openContainer, this.subtitle, this.bytes, this.id});

  final VoidCallback openContainer;
  final String subtitle;
  final Uint8List bytes;
  final String id;

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push<void>(
            context,
            MyLoadingRoute<void>(
                duration: Duration(milliseconds: 500),
                builder: (context) => DetailsPage(
                      bytes: bytes,
                      id: id,
                    )));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Stack(
              children: [_buildImage(context),
                // _buildIcon(context)
              ],
            ),
          ),
          _buildInfo(context),
        ],
      ),
    );
  }

  Widget _buildInfo(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(smallPadding),
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
    );
  }

  Widget _buildIcon(BuildContext context) {
    return Container(
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
                    color: Colors.white,
                    blurRadius: 15.0,
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
                    backgroundImage: AssetImage('assets/bg/waifu.jpg'),
                  ),
                ),
                Text('Made By'),
                Text('UserName'),
              ],
            ),
          ),
          Container(
            child: Text('description'),
          )
        ],
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return Hero(
      tag: '$id',
      child: Container(
        width: MediaQuery.of(context).size.width / 2 - 15,
        height: MediaQuery.of(context).size.width / 2 - 15,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.memory(
            bytes,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
