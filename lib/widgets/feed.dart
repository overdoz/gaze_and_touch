import 'package:flutter/material.dart';

class FeedPostModel {
  final int id;
  final String imgURL;
  final String user;
  final String location;

  FeedPostModel(this.id, this.imgURL, this.user, this.location);
}

// StatelessWidget with UI for our ItemModel-s in ListView.
class FeedPost extends StatelessWidget {
  const FeedPost(this.model, this.onItemTap, {Key key}) : super(key: key);

  final FeedPostModel model;
  final Function onItemTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Enables taps for child and add ripple effect when child widget is long pressed.
      onTap: onItemTap,
      child: ListTile(
        // Useful standard widget for displaying something in ListView.
        leading: Image.network(model.imgURL),
        title: Text(model.user),
      ),
    );
  }
}

/// ------------------------------------------------------------------

class PostCard extends StatelessWidget {
  const PostCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 5 / 6,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Post(),
              _PostImage(),
              // _PostDetails()
            ],
        ),
      ),
    );
  }
}

class _Post extends StatelessWidget {
  const _Post({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _UserImage(),
        _PostTitleAndSummary(),
      ],
    );
  }
}

class _PostTitleAndSummary extends StatelessWidget {
  const _PostTitleAndSummary({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle titleTheme = Theme.of(context).textTheme.title;
    final TextStyle summaryTheme = Theme.of(context).textTheme.body1;
    final String title = "Thanh";
    final String summary = "Paris";

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: titleTheme),
        Text(summary, style: summaryTheme),
      ],
    );
  }
}

class _PostImage extends StatelessWidget {
  const _PostImage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
          aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              alignment: FractionalOffset.topCenter,
              image: NetworkImage("https://images.ctfassets.net/05aprp0cc8ji/U1JPvQ7NLxjruxcoxBXqn/f5c6dcd5585cdd83389e07b7f5be98a6/DER1317867.jpg?w=305&h=230&fit=fill&fm=jpg&fl=progressive"),
            )
          ),
        ),
    );

  }
}

class _PostDetails extends StatelessWidget {
  const _PostDetails({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
       // _UserImage(),
        _UserNameAndEmail()
      ],
    );
  }
}

class _UserNameAndEmail extends StatelessWidget {
  const _UserNameAndEmail({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("username"),
          Text("email"),
        ],
      ),
    );
  }
}

class _UserImage extends StatelessWidget {
  const _UserImage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage("https://img.fotocommunity.com/thanh-le-104b1c57-f139-4ac0-9ca1-a8433d4c8d2f.jpg?width=200&height=200"),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
