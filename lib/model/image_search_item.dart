class ImageSearchItem {
  final String url;
  final String description;
  final int width;
  final int height;

  ImageSearchItem({
    this.url,
    this.description,
    this.width,
    this.height,
  })  : assert(url != null),
        assert(description != null),
        assert(width != null),
        assert(height != null);
}
