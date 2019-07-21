import 'package:flutter/material.dart';
import 'package:upday_dev_task/bloc/bloc.dart';
import 'package:upday_dev_task/colors.dart';
import 'package:upday_dev_task/localization/app_translations.dart';
import 'package:upday_dev_task/widgets/image_search_phrase/disabled_search_button.dart';
import 'package:upday_dev_task/widgets/image_search_phrase/enabled_search_button.dart';

class ImageSearchPhraseWidget extends StatefulWidget {
  ImageSearchPhraseWidget({Key key}) : super(key: key);

  createState() => _ImageSearchPhraseWidgetState();
}

class _ImageSearchPhraseWidgetState extends State<ImageSearchPhraseWidget> {
  final _searchPhraseController = TextEditingController();
  ImageSearchPhraseBloc _imageSearchPhraseBloc;
  SearchStatus _searchStatus;
  String searchPhrase = '';

  final searchTextFieldKey = Key('SearchTextField');
  final searchButtonKey = Key('SearchButton');
  final searchInitKey = Key('SearchInit');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchPhraseController.addListener(_searchPhraseChanged);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _searchPhraseController.dispose();
    _imageSearchPhraseBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _imageSearchPhraseBloc = BlocProvider.of<ImageSearchPhraseBloc>(context);
    return StreamBuilder(
      stream: _imageSearchPhraseBloc.outSearchStatus,
      builder: (context, AsyncSnapshot<SearchStatus> snapshot) {
        if (snapshot.hasData) {
          _searchStatus = snapshot.data;
          return _buildSearchPhraseWidget();
        } else {
          return _buildLoading();
        }
      },
    );
  }

  Widget _buildLoading() {
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildSearchPhraseWidget() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: TextField(
            key: searchTextFieldKey,
            controller: _searchPhraseController,
            decoration: InputDecoration(
                hintText: AppTranslations.of(context).text('search_hint')),
          ),
        ),
        SizedBox(
          width: 16.0,
        ),
        _determineWidgetToDisplay(),
      ],
    );
  }

  _determineWidgetToDisplay() {
    if (_searchStatus == SearchStatus.Fetching) {
      return Container(
        key: searchInitKey,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (searchPhrase.trim().length >= 2) {
      return EnabledSearchButton(
        key: searchButtonKey,
        buttonColor: Theme.of(context).accentColor,
        iconColor: Colors.white,
        onPressed: _startImageSearch,
      );
    } else {
      return DisabledSearchButton(
        buttonColor: Colors.transparent,
        iconColor: Colors.white,
      );
    }
  }

  _searchPhraseChanged() {
    setState(() {
      searchPhrase = _searchPhraseController.text;
    });
  }

  _startImageSearch() {
    FocusScope.of(context).requestFocus(new FocusNode());
    _imageSearchPhraseBloc.inSearchPhrase
        .add(_searchPhraseController.text.trim());
  }
}
