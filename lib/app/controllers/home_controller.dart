import 'package:get/get.dart';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:safe_device/safe_device.dart';

class HomeController extends GetxController {
  HomeController();

  // App Info
  String appName = '';
  String packageName = '';
  String version = '';
  String buildNumber = '';
  String buildSignature = '';
  String? installerStore = '';

  // Safe Info
  bool isJailBroken = false;
  bool isRealDevice = false;
  bool canMockLocation = false;
  bool isOnExternalStorage = false;
  bool isSafeDevice = false;
  bool isDevelopmentModeEnable = false;

  Future<void> fetchAppInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    appName = packageInfo.appName;
    packageName = packageInfo.packageName;
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
    buildSignature = packageInfo.buildSignature;
    installerStore = packageInfo.installerStore;
  }

  Future<void> fetchSafeInfo() async {
    isJailBroken = await SafeDevice.isJailBroken;
    isRealDevice = await SafeDevice.isRealDevice;
    canMockLocation = await SafeDevice.canMockLocation;
    isOnExternalStorage = await SafeDevice.isOnExternalStorage;
    isSafeDevice = await SafeDevice.isSafeDevice;
    isDevelopmentModeEnable = await SafeDevice.isDevelopmentModeEnable;
  }
}
