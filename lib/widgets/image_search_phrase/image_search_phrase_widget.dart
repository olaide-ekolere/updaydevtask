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
  final _textEditingController = TextEditingController();
  ImageSearchPhraseBloc _imageSearchPhraseBloc;
  String searchPhrase ='';

  var searchTextFieldKey = Key('SearchTextField');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textEditingController.addListener(_searchPhraseChanged);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _textEditingController.dispose();
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
    return Container(
      padding: EdgeInsets.all(
        16.0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: TextField(
              key: searchTextFieldKey,
              controller: _textEditingController,
              decoration: InputDecoration(
                  hintText: AppTranslations.of(context).text('search_hint')),
            ),
          ),
          searchPhrase.trim().length >= 2
              ? EnabledSearchButton(
                  buttonColor: kEnabledButton,
                  iconColor: kEnabledIcon,
                  onPressed: _startImageSearch,
                )
              : DisabledSearchButton(
                  buttonColor: kDisabledButton,
                  iconColor: kDisabledIcon,
                )
        ],
      ),
    );
  }

  _searchPhraseChanged() {
    setState(() {
      searchPhrase = _textEditingController.text;
    });
  }

  _startImageSearch() {}
}
