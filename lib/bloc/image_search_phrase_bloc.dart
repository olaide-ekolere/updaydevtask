import 'package:upday_dev_task/bloc/bloc_base.dart';
import 'package:rxdart/subjects.dart';
import 'package:upday_dev_task/data/image_search_data_provider.dart';
import 'package:upday_dev_task/model/Image_search_result.dart';

enum SearchStatus { Initialized, Fetching, Error, Done }

typedef ImageSearchResultObserver(ImageSearchResult imageSearchResult);

class ImageSearchPhraseBloc extends BlocBase {
  final ImageSearchDataProvider imageSearchDataProvider;

  ImageSearchPhraseBloc(this.imageSearchDataProvider) {
    searchStatus = SearchStatus.Initialized;
  }

  //final SearchStatus _countPerPage = 20;
  ReplaySubject<SearchStatus> _searchStatusController =
      ReplaySubject<SearchStatus>();

  Sink<SearchStatus> get _inSearchStatus => _searchStatusController.sink;

  Stream<SearchStatus> get outSearchStatus => _searchStatusController.stream;

  @override
  void dispose() {
    // TODO: implement dispose
    _searchStatusController.close();
  }

  Future<void> startSearchWithPhrase(
    String searchPhrase,
    int pageCount,
    ImageSearchResultObserver imageSearchResultObserver,
  ) async {
    searchStatus = SearchStatus.Fetching;
    return imageSearchDataProvider
        .getImageSearchResults(
      searchPhrase,
      pageCount,
      1,
    )
        .then((imageSearchOperation) {
      if (imageSearchOperation == null || !imageSearchOperation.succeeded) {
        _inSearchStatus.add(SearchStatus.Error);
      } else {
        if (imageSearchResultObserver != null) {
          imageSearchResultObserver(imageSearchOperation.results);
        }
        searchStatus = SearchStatus.Done;
      }
    });
  }

  set searchStatus(SearchStatus searchStatus) =>
      _inSearchStatus.add(searchStatus);

  @override
  cancelOperation() {
    // TODO: implement cancelOperation
    return null;
  }
}
