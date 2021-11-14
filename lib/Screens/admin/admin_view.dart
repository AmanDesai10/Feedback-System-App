import 'package:feedsys/Screens/admin/admin_navigation.dart';
import 'package:feedsys/Screens/admin/desktop/desktop_admin_navigation.dart';
import 'package:feedsys/utils/device_info.dart';
import 'package:flutter/material.dart';

class AdminView extends StatelessWidget {
  const AdminView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = DeviceScreen.isDesktop(context);
    return isDesktop ? DesktopAdminNavigation() : AdminNavigation();
  }
}
