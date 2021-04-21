class FeedPostModel {
  final int id;
  final String imgURL;
  final String username;
  final String userURL;
  final String location;
  final String favLike;
  final int likes;

  FeedPostModel(
      this.id, this.imgURL, this.username, this.userURL, this.location, this.favLike, this.likes);
}