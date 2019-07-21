import 'package:flutter/material.dart';
import 'package:upday_dev_task/bloc/bloc.dart';
import 'package:upday_dev_task/colors.dart';
import 'package:upday_dev_task/localization/app_translations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:upday_dev_task/model/Image_search_result.dart';
import 'package:upday_dev_task/widgets/image_results/image_result_list_item_widget.dart';
import 'package:upday_dev_task/widgets/image_results/no_search_result_widget.dart';
import 'package:upday_dev_task/widgets/image_results/no_search_widget.dart';
import 'package:upday_dev_task/widgets/image_results/search_error_widget.dart';

class ImageSearchResultWidget extends StatefulWidget {
  final ScrollController scrollController;
  ImageSearchResultWidget(this.scrollController, {Key key}) : super(key: key);

  createState() => _ImageSearchResultWidgetState();
}

class _ImageSearchResultWidgetState extends State<ImageSearchResultWidget> {
  ImageSearchResultBloc _imageSearchResultBloc;
  ImageSearchResult imageSearchResult;

  final awaitingFirstPage = Key('awaitingfirstpage');
  final listKey = Key('resultlist');
  final loadMoreKey = Key('loadmore');
  //final _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_scrollController.addListener(_scrollListener);
    widget.scrollController.addListener(_scrollListener);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _imageSearchResultBloc.dispose();
    //_scrollController.dispose();
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
          if(imageSearchResult.imageSearchItems==null&&imageSearchResult.searchPhrase.isNotEmpty) return SearchErrorWidget();
          else if(imageSearchResult.imageSearchItems==null) return NoSearchWidget();
          else if(imageSearchResult.isEmpty) return NoSearchResultWidget();
          else return _buildResultList();
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
    return Column(
      children: <Widget>[
        Expanded(
          child: GridView.builder(
            key: listKey,
            //controller: _scrollController,
            //crossAxisCount: 4,
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.0,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: imageSearchResult.imageSearchItems.length,
            itemBuilder: (context, index) =>
                _buildResultItem(index),
          ),
        ),
        Container(
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
    if(index==imageSearchResult.imageSearchItems.length-1){
      _loadMore();
    }
    return ImageResultListItemWidget(
      imageSearchResult.imageSearchItems[index],
      key: Key('Image${index+1}'),
    );
  }

  _scrollListener(){
    if(widget.scrollController==null||imageSearchResult.imageSearchItems==null)return;
    if(widget.scrollController.offset >= widget.scrollController.position.maxScrollExtent){
      //_loadMore();
      //No longer worked as expected after removing the ScrollController from the GridView to its parent
    }
  }

  _loadMore(){
    if (!imageSearchResult.loadingMore && imageSearchResult.canLoadMore) {
      //load next page
      _imageSearchResultBloc.inLoadMore.add(() {});
    }
  }
}
