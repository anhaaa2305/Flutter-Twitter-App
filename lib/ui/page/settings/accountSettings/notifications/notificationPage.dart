import 'package:flutter/material.dart';
import '../../../../../model/user.dart';
import '../../../../../ui/page/settings/widgets/headerWidget.dart';
import '../../../../../ui/page/settings/widgets/settingsAppbar.dart';
import '../../../../../ui/page/settings/widgets/settingsRowWidget.dart';
import '../../../../../state/authState.dart';
import '../../../../../ui/theme/theme.dart';
import 'package:provider/provider.dart';

class NotificationPageSetting extends StatelessWidget {
  const NotificationPageSetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<AuthState>(context).userModel ?? UserModel();
    return Scaffold(
      backgroundColor: TwitterColor.white,
      appBar: SettingsAppBar(
        title: 'Notifications',
        subtitle: user.userName,
      ),
      body: ListView(
        children: const <Widget>[
          HeaderWidget('Filters'),
          SettingRowWidget(
            "Quality filter",
            showCheckBox: true,
            subtitle:
                'Filter lower-quality from your notifications. This won\'t filter out notifications from people you follow or account you\'ve inteacted with recently.',
          ),
          Divider(height: 0),
          SettingRowWidget("Advanced filter"),
          SettingRowWidget("Muted word"),
          HeaderWidget(
            'Preferences',
            secondHeader: true,
          ),
          SettingRowWidget(
            "Unread notification count badge",
            showCheckBox: false,
            subtitle:
                'Display a badge with the number of notifications waiting for you inside the Fwitter app.',
          ),
          SettingRowWidget("Push notifications"),
          SettingRowWidget("SMS notifications"),
          SettingRowWidget(
            "Email notifications",
            subtitle: 'Control when how often Fwitter sends emails to you.',
          ),
        ],
      ),
    );
  }
}
