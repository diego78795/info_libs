import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:info_libs/app/controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SafeArea(child: Text('Home Page')));
  }
}
