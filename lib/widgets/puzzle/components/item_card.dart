import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photopuzzle/common/constants.dart';
import 'package:photopuzzle/utils/image_util.dart';
import 'package:photopuzzle/widgets/login/components/my_loading_route.dart';

import '../puzzle_detail_page.dart';

class ItemCard extends StatelessWidget {
  const ItemCard(
      {this.openContainer,
      required this.subtitle,
      required this.bytes,
      required this.id,
      required this.index,
      required this.imageUrl});

  final VoidCallback? openContainer;
  final String subtitle;
  final Uint8List bytes;
  final String id;
  final int index;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return _buildBody(context, size);
  }

  Widget _buildBody(BuildContext context, Size size) {
    return GestureDetector(
      key: ValueKey(id),
      onTap: () {
        Navigator.push<void>(
            context,
            MyLoadingRoute<void>(
                duration: Duration(milliseconds: 500),
                builder: (context) => PuzzleDetailsPage(
                      imageUrl: imageUrl,
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
              children: [_buildImage(context, size), _buildIcon(context)],
            ),
          ),
          // _buildInfo(context),
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
                    color: index % 2 == 0 ? Colors.blue : Colors.yellow,
                    blurRadius: 15.0,
                  ),
                ]),
            margin:
                EdgeInsets.only(left: verySmallPadding, top: verySmallPadding),
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
        ],
      ),
    );
  }

  Widget _buildImage(BuildContext context, Size size) {
    return Hero(
      tag: '$id',
      child: Container(
        width: size.width - 32,
        height: size.width - 32,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: imageUrl,
            placeholder: (context, url) => Image.asset('assets/images/placeholder.png'),
            errorWidget: (context, url, dynamic e) => Icon(Icons.error),
          ),

          // Image.memory(
          //   bytes,
          //   fit: BoxFit.cover,
          // ),
        ),
      ),
    );
  }
}
