import 'package:get/get.dart';

import 'package:info_libs/app/ui/home/home_page.dart';
import 'package:info_libs/app/bindings/home_bindings.dart';

part './app_routes.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
        name: Routes.home,
        page: () => const HomePage(),
        binding: HomeBinding()),
  ];
}
