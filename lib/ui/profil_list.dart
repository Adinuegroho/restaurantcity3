import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:restaurantcity3/provider/schedule_provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:restaurantcity3/provider/shared_preferances_provider.dart';

class ProfilList extends StatelessWidget {
  const ProfilList({Key? key}) : super(key: key);
  static const routeName = '/profil_list';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 75,
        backgroundColor: Colors.blue,
        title: const Text('Profile', style: TextStyle(color: Colors.white),),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _notifications(),
          ],
        ),
      ),
    );
  }

  Widget _notifications() {
    return Consumer<SharedPreferencesProvider>(
      builder: (context, provider, child) {
        return ListTile(
          leading: Icon(
            MdiIcons.bell,
            size: 25,
          ),
          title: const Text(
            'Notification',
            style: TextStyle(fontSize: 18),
          ),
          trailing: Consumer<ScheduleProvider>(
            builder: (context, schedule, child) {
              return Switch.adaptive(
                value: provider.notificationSwitch,
                onChanged: (value) async {
                  schedule.scheduledNotification(value);
                  provider.changeNotificationSwitchCondition(value);
                  if (value == true) {
                    Fluttertoast.showToast(
                      msg: 'Notification Enabled',
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                    );
                  } else {
                    Fluttertoast.showToast(
                      msg: 'Notification Disabled',
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                  }
                },
              );
            },
          ),
        );
      },
    );
  }
}