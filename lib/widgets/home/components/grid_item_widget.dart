import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GridItemWidget extends StatelessWidget {
  final String b64;

  const GridItemWidget({Key key, this.b64}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildImageView(b64);
  }

  Widget _buildImageView(String b64) {
    var bytes = Base64Decoder().convert(b64);
    return GestureDetector(
      onTap: () {},
      child: Card(
        child: Container(
          height: 50,
          width: 50,
          child: Image.memory(bytes),
        ),
      ),
    );
  }
}
