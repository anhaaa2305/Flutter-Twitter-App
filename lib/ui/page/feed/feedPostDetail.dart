import 'package:flutter/material.dart';
import '../../../helper/customRoute.dart';
import '../../../helper/enum.dart';
import '../../../model/feedModel.dart';
import '../../../state/authState.dart';
import '../../../state/feedState.dart';
import '../../../ui/theme/theme.dart';
import '../../../widgets/customWidgets.dart';
import '../../../widgets/tweet/tweet.dart';
import '../../../widgets/tweet/widgets/tweetBottomSheet.dart';
import 'package:provider/provider.dart';

class FeedPostDetail extends StatefulWidget {
  const FeedPostDetail({Key? key, required this.postId}) : super(key: key);
  final String postId;

  static Route<void> getRoute(String postId) {
    return SlideLeftRoute<void>(
      builder: (BuildContext context) => FeedPostDetail(
        postId: postId,
      ),
    );
  }

  @override
  _FeedPostDetailState createState() => _FeedPostDetailState();
}

class _FeedPostDetailState extends State<FeedPostDetail> {
  late String postId;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    postId = widget.postId;
    super.initState();
  }

  Widget _floatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        var state = Provider.of<FeedState>(context, listen: false);
        state.setTweetToReply = state.tweetDetailModel!.last;
        Navigator.of(context).pushNamed('/ComposeTweetPage/' + postId);
      },
      child: const Icon(Icons.add),
    );
  }

  Widget _commentRow(FeedModel model) {
    return Tweet(
      model: model,
      type: TweetType.Reply,
      trailing: TweetBottomSheet().tweetOptionIcon(context,
          scaffoldKey: scaffoldKey, model: model, type: TweetType.Reply),
      scaffoldKey: scaffoldKey,
    );
  }

  Widget _tweetDetail(FeedModel model) {
    return Tweet(
      model: model,
      type: TweetType.Detail,
      trailing: TweetBottomSheet().tweetOptionIcon(context,
          scaffoldKey: scaffoldKey, model: model, type: TweetType.Detail),
      scaffoldKey: scaffoldKey,
    );
  }

  void addLikeToComment(String commentId) {
    var state = Provider.of<FeedState>(context, listen: false);
    var authState = Provider.of<AuthState>(context, listen: false);
    state.addLikeToTweet(state.tweetDetailModel!.last, authState.userId);
  }

  void openImage() async {
    Navigator.pushNamed(context, '/ImageViewPge');
  }

  void deleteTweet(TweetType type, String tweetId,
      {required String parentkey}) {
    var state = Provider.of<FeedState>(context, listen: false);
    state.deleteTweet(tweetId, type, parentkey: parentkey);
    Navigator.of(context).pop();
    if (type == TweetType.Detail) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<FeedState>(context);
    return WillPopScope(
      onWillPop: () async {
        Provider.of<FeedState>(context, listen: false)
            .removeLastTweetDetail(postId);
        return Future.value(true);
      },
      child: Scaffold(
        key: scaffoldKey,
        floatingActionButton: _floatingActionButton(),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              title: customTitleText(
                'Thread',
              ),
              iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              bottom: PreferredSize(
                child: Container(
                  color: Colors.grey.shade200,
                  height: 1.0,
                ),
                preferredSize: const Size.fromHeight(0.0),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  state.tweetDetailModel == null ||
                          state.tweetDetailModel!.isEmpty
                      ? Container()
                      : _tweetDetail(state.tweetDetailModel!.last),
                  Container(
                    height: 6,
                    width: double.infinity,
                    color: TwitterColor.mystic,
                  )
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                state.tweetReplyMap == null ||
                        state.tweetReplyMap!.isEmpty ||
                        state.tweetReplyMap![postId] == null
                    ? [
                        //!Removed container
                        const Center()
                      ]
                    : state.tweetReplyMap![postId]!
                        .map((x) => _commentRow(x))
                        .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
