import 'dart:io';
import 'package:upday_dev_task/localization/app_translations.dart';
import 'package:flutter/material.dart';
import 'package:upday_dev_task/bloc/bloc.dart';
import 'package:upday_dev_task/model/image_search.dart';
import 'package:upday_dev_task/widgets/image_results/image_search_results_widget.dart';
import 'package:upday_dev_task/widgets/image_search_phrase/image_search_phrase_widget.dart';

class ImageSearchPage extends StatefulWidget {
  ImageSearchPage({Key key}) : super(key: key);

  createState() => _ImageSearchPageState();
}

class _ImageSearchPageState extends State<ImageSearchPage> {
  ImageSearchBloc _imageSearchBloc;
  ImageSearch _imageSearch;

  final _scrollController = ScrollController();

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    _imageSearchBloc = BlocProvider.of<ImageSearchBloc>(context);
    return Scaffold(
      body: StreamBuilder(
        stream: _imageSearchBloc.outImageSearch,
        builder: (context, AsyncSnapshot<ImageSearch> snapshot) {
          if (snapshot.hasData) {
            _imageSearch = snapshot.data;
            return _buildSearchWidget();
          } else {
            return _buildLoading();
          }
        },
      ),
    );
  }

  Widget _buildLoading() {
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildSearchWidget() {
    return NestedScrollView(
      controller: _scrollController,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          new SliverAppBar(
            title: new Text(
              AppTranslations.of(context).text('app_text'),
            ),
            pinned: true,
            floating: true,
            forceElevated: innerBoxIsScrolled,
            bottom: PreferredSize(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    bottom: 16.0,
                  ),
                  child: BlocProvider(
                    child: ImageSearchPhraseWidget(),
                    bloc: _imageSearch.imageSearchPhraseBloc,
                  ),
                ),
                preferredSize: Size.fromHeight(
                  64.0,
                )),
          ),
        ];
      },
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: BlocProvider(
          child: ImageSearchResultWidget(_scrollController),
          bloc: _imageSearch.imageSearchResultBloc,
        ),
      ),
    );
  }

}
