
import 'package:upday_dev_task/model/image_search_operation.dart';

abstract class ImageSearchDataProvider{
  Future<ImageSearchOperation> getImageSearchResults(String searchPhrase, int pageCount, int page);
}