import 'package:flutter/material.dart';
import 'package:upday_dev_task/bloc/bloc.dart';
import 'package:upday_dev_task/colors.dart';
import 'package:upday_dev_task/localization/app_translations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:upday_dev_task/model/Image_search_result.dart';
import 'package:upday_dev_task/widgets/image_results/image_result_list_item_widget.dart';

class ImageSearchResultWidget extends StatefulWidget {
  ImageSearchResultWidget({Key key}) : super(key: key);

  createState() => _ImageSearchResultWidgetState();
}

class _ImageSearchResultWidgetState extends State<ImageSearchResultWidget> {
  ImageSearchResultBloc _imageSearchResultBloc;
  ImageSearchResult imageSearchResult;

  final awaitingFirstPage = Key('awaitingfirstpage');
  final listKey = Key('resultlist');
  final loadMoreKey = Key('loadmore');
  final _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_scrollListener);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _imageSearchResultBloc.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _imageSearchResultBloc = BlocProvider.of<ImageSearchResultBloc>(context);
    return StreamBuilder(
      stream: _imageSearchResultBloc.outImageSearchResult,
      builder: (context, AsyncSnapshot<ImageSearchResult> snapshot) {
        if (snapshot.hasData) {
          imageSearchResult = snapshot.data;
          return _buildResultList();
        } else {
          return _buildLoading();
        }
      },
    );
  }

  Widget _buildLoading() {
    return Container(
      key: awaitingFirstPage,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildResultList() {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        GridView.builder(
          key: listKey,
          controller: _scrollController,
          //crossAxisCount: 4,
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.6,
          ),
          itemCount: imageSearchResult.imageSearchItems.length,
          itemBuilder: (context, index) =>
              _buildResultItem(index),
          /*
          staggeredTileBuilder: (int index) =>
              StaggeredTile.count(2, index.isEven ? 2 : 1),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          */
        ),
        Positioned(
          bottom: 0.0,
          top: 0.0,
          child: imageSearchResult.loadingMore
              ? CircularProgressIndicator(
            key: loadMoreKey,
          )
              : SizedBox(
            height: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildResultItem(int index) {
    return ImageResultListItemWidget(
      imageSearchResult.imageSearchItems[index],
      key: Key('Image${index+1}'),
    );
  }

  _scrollListener(){
    if(_scrollController.offset >= _scrollController.position.maxScrollExtent){
      if (!imageSearchResult.loadingMore && imageSearchResult.canLoadMore) {
        //load next page
        _imageSearchResultBloc.inLoadMore.add(() {});
      }
    }
  }
}
