import 'package:flutter/material.dart';
import '../../../../../helper/utility.dart';
import '../../../../../ui/page/settings/widgets/headerWidget.dart';
import '../../../../../ui/page/settings/widgets/settingsRowWidget.dart';
import '../../../../../ui/theme/theme.dart';
import '../../../../../widgets/customAppBar.dart';
import '../../../../../widgets/customWidgets.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TwitterColor.white,
      appBar: CustomAppBar(
        isBackButton: true,
        title: customTitleText(
          'About Twitter',
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          const HeaderWidget(
            'Help',
            secondHeader: true,
          ),
          SettingRowWidget(
            "Help Centre",
            vPadding: 0,
            showDivider: false,
            onPressed: () {
              Utility.launchURL(
                  "https://github.com/anhaaa2305");
            },
          ),
          const HeaderWidget('Legal'),
          const SettingRowWidget(
            "Terms of Service",
            showDivider: true,
          ),
          const SettingRowWidget(
            "Privacy policy",
            showDivider: true,
          ),
          const SettingRowWidget(
            "Cookie use",
            showDivider: true,
          ),
          SettingRowWidget(
            "Legal notices",
            showDivider: true,
            onPressed: () async {
              showLicensePage(
                context: context,
                applicationName: 'Twitter',
                applicationVersion: '1.0.0',
                useRootNavigator: true,
              );
            },
          ),
          const HeaderWidget('Developer'),
          SettingRowWidget("Github", showDivider: true, onPressed: () {
            Utility.launchURL("https://github.com/anhaaa2305");
          }),
          SettingRowWidget("LinkedIn", showDivider: true, onPressed: () {
            Utility.launchURL("https://www.linkedin.com/in/haluuvan-anh-8835a0273/");
          }),
          SettingRowWidget("Twitter", showDivider: true, onPressed: () {
            Utility.launchURL("https://twitter.com/TheAlphaMerc");
          }),
          SettingRowWidget("Facebook", showDivider: true, onPressed: () {
            Utility.launchURL("https://www.facebook.com/haluuvananh");
          }),
        ],
      ),
    );
  }
}
