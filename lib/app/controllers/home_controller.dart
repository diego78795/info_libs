import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:share_plus/share_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safe_device/safe_device.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HomeController extends GetxController {
  HomeController();

  String environment = 'development';
  bool suport32Bits = true;
  bool suport64Bits = true;

  bool isLoading = true;
  String qrCodeImage =
      'https://cdn.qr-code-generator.com/account27137545/qrcodes/67477421.png?Expires=1687890071&Signature=pSjv0f9dZGZxqRyLVm~B3UiYbgbXcVk2Lm1hoHE45kkmsXeZu5E6zvgI2YJq1nNDR0c-IiMwL3vbPUSEU4n~RMICLf8CN-KE2dqVNqEq2PJwOOvaGbfwoG-unEtt2DtvmPYcImSM-9~MEbPHt4qPeu8xoliLDVWgjAyxjZuzB3jXX3CSEwQ1j7spR4u~tZQrJOmzPihQncmB0F8aLyw9slyyunoaGoQ6ACBIOS6RgOsvLkAU7QIE7ixjdmMtmqNpZBaiQhZ-jcAiskn1VDN6GTNu2F5OEcAH9-xG0gmPtDYDuesDWZIyxMVMENRnJ3gTdofhXl94o4~yy6ayfi18bA__&Key-Pair-Id=KKMPOJU8AYATR';

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

  // Device Info
  Map<String, dynamic> deviceData = {};

  Future<String> getImage(String urlImage) async {
    final url = Uri.parse(urlImage);
    final response = await http.get(url);
    final bytes = response.bodyBytes;
    final temp = await getTemporaryDirectory();
    final path = '${temp.path}/image.png';
    File(path).writeAsBytesSync(bytes);
    return path;
  }

  Future<void> handleShare({String? text, String? urlImage}) async {
    if (text != null && urlImage != null) {
      String file = await getImage(urlImage);
      Share.shareFiles([file], text: text);
    } else if (text != null) {
      Share.share(text);
    } else if (urlImage != null) {
      String file = await getImage(urlImage);
      Share.shareFiles([file]);
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
    await fetchDeviceInfo();
    await checkRequirements();
    isLoading = false;
    update();
  }

  Future<void> checkRequirements() async {
    if (environment == 'production' && isSafeDevice) {
      debugPrint('Este dispositivo não é seguro');
    } else if (suport32Bits && deviceData['supported32BitAbis'].isEmpty) {
      debugPrint('Este dispositivo não é tem suporte para 32 bits');
    } else if (suport64Bits && deviceData['supported64BitAbis'].isEmpty) {
      debugPrint('Este dispositivo não é tem suporte para 64 bits');
    }
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

  Future<void> fetchDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    deviceData = switch (defaultTargetPlatform) {
      TargetPlatform.android =>
        getDeviceInfoAndroid(await deviceInfo.androidInfo),
      TargetPlatform.iOS => const <String, dynamic>{
          'Error:': 'Este aplicativo não possui suporte para iOS'
        },
      TargetPlatform.linux => <String, dynamic>{
          'Error:': 'Este aplicativo não possui suporte para linux'
        },
      TargetPlatform.windows => <String, dynamic>{
          'Error:': 'Este aplicativo não possui suporte para windows'
        },
      TargetPlatform.macOS => <String, dynamic>{
          'Error:': 'Este aplicativo não possui suporte para macOS'
        },
      TargetPlatform.fuchsia => <String, dynamic>{
          'Error:': 'Este aplicativo não possui suporte para fuchsia'
        }
    };
    update();
  }

  Map<String, dynamic> getDeviceInfoAndroid(AndroidDeviceInfo build) {
    return {
      'model': build.model,
      'hardware': build.hardware,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'host': build.host,
      'id': build.id,
      'widthPx': build.displayMetrics.widthPx,
      'heightPx': build.displayMetrics.heightPx,
      'serialNumber': build.serialNumber,
    };
  }
}
