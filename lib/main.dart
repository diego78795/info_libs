import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:info_libs/app/routes/app_pages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Info Libs',
      initialRoute: Routes.home,
      getPages: AppPages.pages,
      debugShowCheckedModeBanner: false,
    );
  }
}
