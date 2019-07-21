import 'package:upday_dev_task/bloc/bloc.dart';

class ImageSearch {
  final ImageSearchPhraseBloc imageSearchPhraseBloc;
  final ImageSearchResultBloc imageSearchResultBloc;

  ImageSearch({this.imageSearchPhraseBloc, this.imageSearchResultBloc}) :
  assert(imageSearchPhraseBloc!=null),
  assert(imageSearchResultBloc!=null){
    imageSearchPhraseBloc.outImageSearchResult.listen(
      (imageSearchResult) =>
          imageSearchResultBloc.initWithImageSearchItems(imageSearchResult),
    );
  }
}
