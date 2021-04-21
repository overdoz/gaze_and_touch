import 'package:flutter/material.dart';
import 'package:gazeAndTouch/models/post_model.dart';

class PostCard extends StatelessWidget {
  final FeedPostModel model;
  const PostCard(this.model, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 5 / 7,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Post(this.model),
            _PostImage(model.imgURL),
            _PostDetails(),
            _Likes(model.favLike, model.likes),
          ],
        ),
      ),
    );
  }
}

class _Post extends StatelessWidget {
  final FeedPostModel model;
  const _Post(this.model, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _UserImage(model.userURL),
        _PostNameAndLocation(model.username, model.location),
      ],
    );
  }
}

/// Username and Location of this post
class _PostNameAndLocation extends StatelessWidget {
  final String username;
  final String location;
  const _PostNameAndLocation(this.username, this.location, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle titleTheme = Theme.of(context).textTheme.title;
    final TextStyle summaryTheme = Theme.of(context).textTheme.body1;


    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(this.username, style: titleTheme),
        Text(this.location, style: summaryTheme),
      ],
    );
  }
}

/// Posted image with squared aspect ratio
class _PostImage extends StatelessWidget {
  final String imgURL;
  const _PostImage(this.imgURL, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          fit: BoxFit.cover,
          alignment: FractionalOffset.topCenter,
          image: AssetImage(
              this.imgURL),
        )),
      ),
    );
  }
}

/// determines how many likes this post received
/// [name] shows the leading username of people which liked this post
/// [count] displays the amount of remaining likes
class _Likes extends StatelessWidget {
  final String name;
  final int count;

  const _Likes(this.name, this.count, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Liked by ",
          style: TextStyle(
            color: Colors.black.withOpacity(0.8),
          ),
        ),
        Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          " and ",
          style: TextStyle(
            color: Colors.black.withOpacity(0.8),
          ),
        ),
        Text(
          "$count others",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

/// interaction options for each post
/// there are 3 icons without any functionality right now
class _PostDetails extends StatelessWidget {
  const _PostDetails({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // _UserImage(),
        // _UserNameAndEmail()
        SizedBox(
          width: 10,
        ),
        Icon(
          Icons.favorite_border,
          color: Colors.grey,
          size: 24.0,
          semanticLabel: 'Text to announce in accessibility modes',
        ),
        SizedBox(
          width: 10,
        ),
        Icon(
          Icons.chat_bubble_outline,
          color: Colors.grey,
          size: 24.0,
          semanticLabel: 'Text to announce in accessibility modes',
        ),
        SizedBox(
          width: 10,
        ),
        Icon(
          Icons.send_outlined,
          color: Colors.grey,
          size: 24.0,
          semanticLabel: 'Text to announce in accessibility modes',
        ),
      ],
    );
  }
}

/// avatar of user in the upper left corner
class _UserImage extends StatelessWidget {
  final String userURL;
  const _UserImage(this.userURL, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: CircleAvatar(
        radius: 30,
        backgroundImage: AssetImage(
            this.userURL),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
