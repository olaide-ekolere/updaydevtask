class ImageSearchItem {
  final String url;
  final String description;

  ImageSearchItem(
    this.url,
    this.description,
  )   : assert(url != null),
        assert(description != null);
}
