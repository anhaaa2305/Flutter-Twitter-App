import 'package:flutter/material.dart';
import '../../../state/authState.dart';
import '../../../state/suggestionUserState.dart';
import '../../../state/searchState.dart';
import '../../../ui/page/common/widget/userListWidget.dart';
import '../../../ui/theme/theme.dart';
import '../../../widgets/customFlatButton.dart';
import '../../../widgets/newWidget/customLoader.dart';
import '../../../widgets/newWidget/emptyList.dart';
import '../../../widgets/newWidget/title_text.dart';
import 'package:provider/provider.dart';

class SuggestedUsers extends StatefulWidget {
  const SuggestedUsers({Key? key, this.appbar}) : super(key: key);
  final SliverAppBar? appbar;

  @override
  State<SuggestedUsers> createState() => _SuggestedUsersState();
}

class _SuggestedUsersState extends State<SuggestedUsers> {
  late ValueNotifier<bool> isLoading;
  @override
  void initState() {
    isLoading = ValueNotifier<bool>(false);
    super.initState();
  }

  @override
  void dispose() {
    isLoading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = context.watch<SearchState>();
    final authState = context.watch<AuthState>();
    final state = context.watch<SuggestionsState>();
    state.setUserlist(searchState.userlist);

    final isFollowListAvailable = !searchState.isBusy &&
        searchState.userlist != null &&
        searchState.userlist!.isNotEmpty;

    final userToFollowCount = isFollowListAvailable
        ? state.userlist!.length > 5
            ? 5
            : state.userlist!.length
        : 0;

    return Scaffold(
      bottomNavigationBar: !isFollowListAvailable
          ? null
          : BottomAppBar(
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: state.selectedUsersCount >= userToFollowCount
                          ? SizedBox()
                          : Text(
                              '${userToFollowCount - state.selectedUsersCount} more to follow',
                              style: TextStyles.titleStyle,
                            ),
                    ),
                    TextButton(
                      onPressed: () {
                        state.displaySuggestions = false;
                      },
                      child: Text('Skip'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: CustomFlatButton(
                        onPressed: state.selectedUsersCount == 0
                            ? null
                            : () async {
                                isLoading.value = true;
                                await state.followUsers();
                                isLoading.value = false;
                              },
                        label: 'Follow ${state.selectedUsersCount}',
                        isWrapped: true,
                        borderRadius: 50,
                        labelStyle: TextStyles.onPrimaryTitleText,
                        color: state.selectedUsersCount == 0
                            ? Colors.grey[350]
                            : TwitterColor.dodgeBlue,
                        isLoading: isLoading,
                      ),
                    ),
                  ],
                ),
              ),
            ),
      body: SafeArea(
        child: Container(
          child: searchState.isBusy
              ? SizedBox(
                  height: context.height,
                  child: const CustomScreenLoader(
                    height: double.infinity,
                    width: double.infinity,
                    backgroundColor: Colors.white,
                  ),
                )
              : CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      title:
                          Image.asset('assets/images/icon-480.png', height: 40),
                      backgroundColor:
                          Theme.of(context).appBarTheme.backgroundColor,
                      centerTitle: true,
                      pinned: true,
                      primary: true,
                      elevation: 2,
                      expandedHeight:
                          kToolbarHeight + (isFollowListAvailable ? 180 : 100),
                      flexibleSpace: FlexibleSpaceBar(
                        stretchModes: const <StretchMode>[
                          StretchMode.zoomBackground,
                          StretchMode.blurBackground
                        ],
                        background: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: kToolbarHeight),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TitleText('Suggestions for you to follow'),
                                  SizedBox(height: 8),
                                  Text(
                                    'When you follow someone, you\'ll see their Tweets in your Home Timeline',
                                    style: TextStyles.textStyle14,
                                  ),
                                ],
                              ),
                            ),
                            if (isFollowListAvailable) ...[
                              Divider(),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TitleText('You may be Interested In'),
                                    IconButton(
                                      onPressed: () {
                                        state.toggleAllSelections();
                                      },
                                      icon: state.selectedUsersCount ==
                                              state.userlist!.length
                                          ? Icon(
                                              Icons.check_circle,
                                              color: TwitterColor.dodgeBlue,
                                            )
                                          : Icon(
                                              Icons.add_circle_outline_outlined,
                                              color: Colors.grey,
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(),
                            ],
                          ],
                        ),
                      ),
                    ),
                    !isFollowListAvailable
                        ? SliverFillRemaining(
                            child: Column(
                              children: [
                                SizedBox(height: 100),
                                NotifyText(
                                    subTitle: 'No user available to follow'),
                                TextButton(
                                  onPressed: () {
                                    state.displaySuggestions = false;
                                  },
                                  child: Text('Skip'),
                                ),
                              ],
                            ),
                          )
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final user = state.userlist != null
                                    ? state.userlist![index]
                                    : null;

                                if (user == null) {
                                  return SizedBox();
                                }
                                return UserTile(
                                  user: user,
                                  currentUser: authState.userModel!,
                                  onTrailingPressed: () {
                                    state.toggleUserSelection(user);
                                  },
                                  trailing: IconButton(
                                    onPressed: null,
                                    icon: state.isSelected(user)
                                        ? Icon(
                                            Icons.check_circle,
                                            color: TwitterColor.dodgeBlue,
                                          )
                                        : Icon(
                                            Icons.add_circle_outline_outlined),
                                  ),
                                );
                              },
                              childCount: state.userlist?.length ?? 0,
                            ),
                          )
                  ],
                ),
        ),
      ),
    );
  }
}
