import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:info_libs/app/controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GetBuilder<HomeController>(builder: (_) {
      return SafeArea(
          child: ListView(padding: const EdgeInsets.all(10), children: [
        Container(
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black)),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                    child: Text("Informações do aplicativo",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold))),
                SizedBox(height: 10),
                TextInfo(label: 'Nome', data: _.appName),
                TextInfo(label: 'Nome do aplicativo', data: _.packageName),
                TextInfo(label: 'Versão', data: _.version),
                TextInfo(label: 'Numero do build', data: _.buildNumber),
                TextInfo(label: 'Assinatura do build', data: _.buildSignature),
                TextInfo(
                    label: 'Loja que foi instalado',
                    data: '${_.installerStore}'),
              ],
            ))
      ]));
    }));
  }
}

class TextInfo extends StatelessWidget {
  const TextInfo({super.key, required this.label, required this.data});

  final String label;
  final String data;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (_) {
        return Text(
          "$label: $data",
          style: const TextStyle(
            fontSize: 16,
          ),
        );
      },
    );
  }
}
