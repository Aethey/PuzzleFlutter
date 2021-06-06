import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photopuzzle/common/constants.dart';
import 'package:photopuzzle/states/provider/puzzle/puzzle_list_provider.dart';

import 'components/item_card.dart';

class PuzzleListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PuzzleListState();
  }
}

class PuzzleListState extends State<PuzzleListPage>
    with AutomaticKeepAliveClientMixin {
  final picker = ImagePicker();
  int puzzleTag = 0002;
  DocumentSnapshot<Object>? last;
  static late ScrollController _scrollController;
  int oldLength = 0;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  void didUpdateWidget(PuzzleListPage oldWidget) {
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
      child: _buildImageList(),
    );
  }

  Widget _buildImageList() {
    return Container(
      child: Consumer(
        builder: (context, watch, _) {
          final isLoadMoreError = watch(puzzleProvider).isLoadMoreError;
          final isLoadMoreDone = watch(puzzleProvider).isLoadMoreDone;
          final isLoading = watch(puzzleProvider).isLoading;
          final docs = watch(puzzleProvider).puzzles;
          oldLength = docs?.length ?? 0;
          if (docs == null) {
            if (isLoading == false) {
              //  NONE
              return _buildNoneWidget(context);
            }
            // Loading Large
            return _buildLoadingWidget(context);
          }
          return RefreshIndicator(
            backgroundColor: Colors.grey,
            color: Colors.white,
            onRefresh: () => context.read(puzzleProvider.notifier).refresh(),
            child: ListView.builder(
                controller: _scrollController,
                cacheExtent: MediaQuery.of(context).size.height,
                itemCount: docs.length + 1,
                itemBuilder: (context, i) {
                  if (i == docs.length) {
                    if (isLoadMoreError) {
                      //  ERROR
                      return _buildNoneWidget(context);
                    }

                    if (isLoadMoreDone) {
                      return Center(
                        child: Text(''),
                      );
                    }
                    return Center(
                      // width: MediaQuery.of(context).size.width,
                      // padding: EdgeInsets.symmetric(horizontal: mediumPadding),
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.grey,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    );
                  }

                  Uint8List bytes =
                      Base64Decoder().convert(docs[i]['b64'].toString());
                  String id = docs[i].id;
                  return animContainer(
                      docs[i]['imageUrl'].toString(), bytes, id, i);
                }),
          );
        },
      ),
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

  Widget _buildLoadingWidget(BuildContext context) {
    return Container(
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget animContainer(String imageUrl, Uint8List bytes, String id, int index) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(smallPadding),
        child: ItemCard(
          subtitle: 'Secondary text',
          id: id,
          bytes: bytes,
          index: index,
          imageUrl: imageUrl,
        ),
      ),
    );
  }

  void _scrollListener() {
    double maxScroll = _scrollController.position.maxScrollExtent;
    double currentScroll = _scrollController.position.pixels;

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _scrollController.addListener(() {
        // scrolling
      });
      _scrollController.position.isScrollingNotifier.addListener(() {
        if (!_scrollController.position.isScrollingNotifier.value) {
          // stop

          if (currentScroll > maxScroll &&
              !context.read(puzzleProvider).isLoading &&
              _scrollController.position.extentAfter == 0) {
            print(currentScroll);
            print('?????');
            print(maxScroll);
            context.read(puzzleProvider.notifier).loadMore();
          }
        } else {
          // start
        }
      });
    });
  }

  @override
  bool get wantKeepAlive => true;
}
