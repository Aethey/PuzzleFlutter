import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photopuzzle/common/constants.dart';
import 'package:photopuzzle/states/provider/photo/photo_list_provider.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import 'components/photo_item.dart';

final showAppBarProvider = StateProvider((ref) => true);
final showCancelProvider = StateProvider((ref) => false);

class PhotoListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PhotoListState();
}

class PhotoListState extends State<PhotoListPage>
    with AutomaticKeepAliveClientMixin {
  PhotoListState({Key? key});

  static late ScrollController _scrollController;
  static late FocusNode _focusNode;

  int oldLength = 0;
  int curLastIndex = 0;
  bool isScrollingDown = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(_focusListener);
    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  void didUpdateWidget(PhotoListPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: _buildBody(),
    );
  }

  SafeArea _buildBody() {
    return SafeArea(
      child: Column(
        children: <Widget>[
          _buildHideAbleAppBar(),
          Expanded(
            child: _buildPhotoList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHideAbleAppBar() {
    return Consumer(
      builder: (context, watch, _) {
        return Container(
          // width: MediaQuery.of(context).size.width,
          child: AnimatedContainer(
            width: MediaQuery.of(context).size.width -
                (watch(showCancelProvider).state ? 50 : 0),
            height: watch(showAppBarProvider).state ? bigSize : 0.0,
            duration: Duration(milliseconds: 200),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: smallPadding),
                    child: TextField(
                      focusNode: _focusNode,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                watch(showCancelProvider).state
                    ? _buildCancelButton()
                    : Container()
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCancelButton() {
    return GestureDetector(
      onTap: () {
        _focusNode.unfocus();
      },
      child: Padding(
        padding: const EdgeInsets.only(right: smallPadding),
        child: Text(
          'cancel',
          style: TextStyle(
              fontSize: mediumText,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildPhotoList() {
    return Consumer(
      builder: (context, watch, _) {
        final isLoadMoreError = watch(photoProvider).isLoadMoreError;
        final isLoadMoreDone = watch(photoProvider).isLoadMoreDone;
        final isLoading = watch(photoProvider).isLoading;
        final photos = watch(photoProvider).photos;
        oldLength = photos?.length ?? 0;
        if (photos == null) {
          if (isLoading == false) {
            //  NONE
            return _buildNoneWidget(context);
          }
          // Loading Large
          return _buildNoneWidget(context);
        }
        return WaterfallFlow.builder(
            //cacheExtent: 0.0,
            itemCount: photos.length + 1,
            controller: _scrollController,
            gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
              viewportBuilder: (int firstIndex, int lastIndex) {
                curLastIndex = lastIndex;
              },
              lastChildLayoutTypeBuilder: (index) => index == photos.length
                  ? LastChildLayoutType.fullCrossAxisExtent
                  : LastChildLayoutType.none,
            ),
            itemBuilder: (BuildContext context, int i) {
              if (i == photos.length) {
                if (isLoadMoreDone) {
                  return Center(
                    child: Text(''),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.grey,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                );
              }
              return PhotoItem(i, photos[i]);
            });
      },
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

  void _focusListener() {
    context.read(showCancelProvider).state = _focusNode.hasFocus;
  }

  void _scrollListener() {
    _focusNode.unfocus();
    double maxScroll = _scrollController.position.maxScrollExtent;
    double currentScroll = _scrollController.position.pixels;
    // use for loadMore
    // judge by current currentScroll distance
    if (currentScroll > maxScroll &&
        !context.read(photoProvider).isLoading &&
        _scrollController.position.extentAfter == 0) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        _scrollController.addListener(() {
          // scrolling
        });
        _scrollController.position.isScrollingNotifier.addListener(() {
          // stop
          if (!_scrollController.position.isScrollingNotifier.value) {
            if (oldLength == context.read(photoProvider).photos!.length) {
              // judge by current show Last item，
              if (curLastIndex >=
                  context.read(photoProvider).photos!.length - 4) {
                context.read(photoProvider.notifier).loadMore();
              }
            }
          } else {
            // start
          }
        });
      });
    }
    // use for hide appBar
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (!isScrollingDown) {
        isScrollingDown = true;
        context.read(showAppBarProvider).state = false;
      }
    }

    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (isScrollingDown) {
        isScrollingDown = false;
        context.read(showAppBarProvider).state = true;
        setState(() {});
      }
    }
  }

  @override
  bool get wantKeepAlive => true;
}
