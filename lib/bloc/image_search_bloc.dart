
import 'package:upday_dev_task/bloc/bloc_base.dart';
import 'package:upday_dev_task/bloc/image_search_phrase_bloc.dart';
import 'package:upday_dev_task/bloc/image_search_result_bloc.dart';

class ImageSearchBloc extends BlocBase{
  final ImageSearchPhraseBloc imageSearchPhraseBloc;
  final ImageSearchResultBloc imageSearchResultBloc;
  ImageSearchBloc({this.imageSearchPhraseBloc, this.imageSearchResultBloc});
  @override
  void dispose() {
    // TODO: implement dispose
    imageSearchPhraseBloc.dispose();
    imageSearchResultBloc.dispose();
  }

}