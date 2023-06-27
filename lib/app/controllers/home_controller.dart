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

  bool isLoading = true;
  String qrCodeImage =
      'https://cdn.qr-code-generator.com/account27137545/qrcodes/67477421.png?Expires=1687886290&Signature=NHyQ2x~tKgKWNoA~BAvVB5F7hZlvwzvh-tTNNPgaY6LyjqEut1j03gVQIp4iRD~D1Bt9n1IVIPQ5gVrHKPTafdxlSr3AhpdhKD3FJyC8vZ96M5jSLBXQXaKM~dwMr87KLAVlxSzYHTncMAffNa7A58ULFqiJWcPPte2Bgk9TeAkdxp-s2EdmDMXEpJSSfpmHPcK6cN5R9A5ewlrvB3dJKvSiwVBMlaDbQTOQpBoOENeNq7LIF23EAtLaJi6ZfwNrwsm7zhV5VZvdpSkZaqjThTOIRqWBpIZcPkwYE2u6aKtsoAphWfdS6wWBaiHwHd7SpmrQwrvYaepIWPmJjjQ-Mw__&Key-Pair-Id=KKMPOJU8AYATR';

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
