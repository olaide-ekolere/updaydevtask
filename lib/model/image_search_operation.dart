import 'package:upday_dev_task/model/Image_search_result.dart';

class ImageSearchOperation{
  final int code;
  final dynamic _result;
  ImageSearchOperation(this.code, this._result);
  bool get succeeded => code == 200;
  ImageSearchResult get results => succeeded? _result as ImageSearchResult : null;
  String get message => succeeded? null : '$_result';
}