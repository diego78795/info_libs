import 'package:get/get.dart';

import 'package:package_info_plus/package_info_plus.dart';

class HomeController extends GetxController {
  HomeController();

  //Info app
  String appName = '';
  String packageName = '';
  String version = '';
  String buildNumber = '';

  Future<void> fetchInfoApp() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    appName = packageInfo.appName;
    packageName = packageInfo.packageName;
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
  }
}
