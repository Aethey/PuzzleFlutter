import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photopuzzle/common/constants.dart';
import 'package:photopuzzle/states/provider/puzzle/puzzle_list_provider.dart';

import 'components/item_card.dart';

/// puzzle image list page
class PuzzleListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PuzzleListState();
  }
}

class PuzzleListState extends State<PuzzleListPage>
    with AutomaticKeepAliveClientMixin {
  /// use for hero animation
  int puzzleTag = 0002;

  /// the puzzle image list data
  /// get from firebase
  DocumentSnapshot<Object>? last;

  /// puzzle listview ScrollController
  static late ScrollController _scrollController;

  /// last request list length
  /// Judging for loadMore timing
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
      child: _buildImageList(context),
    );
  }

  Widget _buildImageList(BuildContext context) {
    return Container(
      child: Consumer(
        builder: (context, watch, _) {
          // puzzle listView state
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

          /// use for push to refresh
          return RefreshIndicator(
            backgroundColor: Theme.of(context).shadowColor,
            color: Theme.of(context).primaryColor,
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

                    if (docs.length < 4) {
                      return Container();
                    }
                    return Center(
                      // width: MediaQuery.of(context).size.width,
                      // padding: EdgeInsets.symmetric(horizontal: mediumPadding),
                      child: CircularProgressIndicator(
                        backgroundColor: Theme.of(context).shadowColor,
                        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                      ),
                    );
                  }
                  String id = docs[i].id;
                  return itemContainer(docs[i]['imageUrl'].toString(), id, i);
                }),
          );
        },
      ),
    );
  }

  /// if none then show
  Widget _buildNoneWidget(BuildContext context) {
    return Container(
      child: Center(
          child: Text(
        'NONE',
        style: Theme.of(context).textTheme.headline2,
      )),
    );
  }

  /// if need loading then show
  Widget _buildLoadingWidget(BuildContext context) {
    return Container(
      child: Center(child: CircularProgressIndicator()),
    );
  }

  /// list item widget
  Widget itemContainer(String imageUrl, String id, int index) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(smallPadding),
        child: ItemCard(
          id: id,
          index: index,
          imageUrl: imageUrl,
        ),
      ),
    );
  }

  /// listen scroll state
  /// use for loadMore
  void _scrollListener() {
    double maxScroll = _scrollController.position.maxScrollExtent;
    double currentScroll = _scrollController.position.pixels;

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _scrollController.addListener(() {
        // scrolling
      });
      _scrollController.position.isScrollingNotifier.addListener(() {
        if (!_scrollController.position.isScrollingNotifier.value) {
          /// if listview scroll stop and scroll distance > maxScroll
          // stop
          if (currentScroll > maxScroll &&
              !context.read(puzzleProvider).isLoading &&
              _scrollController.position.extentAfter == 0) {
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
