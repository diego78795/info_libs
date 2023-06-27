import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:share_plus/share_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safe_device/safe_device.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HomeController extends GetxController {
  HomeController();

  bool isLoading = true;

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

  Future<void> handleShare({String? text, String? file}) async {
    if (text != null && file != null) {
      Share.shareXFiles([XFile(file)], text: text);
    } else if (text != null) {
      Share.share(text);
    } else if (file != null) {
      Share.shareXFiles([XFile(file)]);
    }
  }

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  Future<void> fetchData() async {
    await fetchAppInfo();
    await fetchSafeInfo();
    isLoading = false;
    update();
  }

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
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        const CupertinoAlertDialog(title: Text('Permissão negada'));
      } else {
        canMockLocation = await SafeDevice.canMockLocation;
      }
    } else if (permission == LocationPermission.deniedForever) {
      const CupertinoAlertDialog(
          title: Text(
              'Não foi possivel verificar se a localização é emulada pois não temos permissão'));
    } else {
      canMockLocation = await SafeDevice.canMockLocation;
    }
    isOnExternalStorage = await SafeDevice.isOnExternalStorage;
    isSafeDevice = await SafeDevice.isSafeDevice;
    isDevelopmentModeEnable = await SafeDevice.isDevelopmentModeEnable;
  }
}
