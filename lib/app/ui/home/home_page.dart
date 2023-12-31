import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:info_libs/app/controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GetBuilder<HomeController>(builder: (_) {
      return _.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(10),
                  children: [
                  CardInfo(title: 'Informações do aplicativo', data: [
                    {'label': 'Nome;', 'data': _.appName},
                    {'label': 'Nome do aplicativo:', 'data': _.packageName},
                    {'label': 'Versão:', 'data': _.version},
                    {'label': 'Numero do build:', 'data': _.buildNumber},
                    {'label': 'Assinatura do build:', 'data': _.buildSignature},
                    {
                      'label': 'Loja que foi instalado',
                      'data': '${_.installerStore}'
                    },
                  ]),
                  const SizedBox(height: 20),
                  CardInfo(title: 'Informações de segurança', data: [
                    {
                      'label': 'Tem jailbreak ou é um android?',
                      'data': _.isJailBroken ? 'Sim' : 'Não'
                    },
                    {
                      'label': 'É um dispositivo real?',
                      'data': _.isRealDevice ? 'Sim' : 'Não'
                    },
                    {
                      'label': 'Esta com a localização emulada?',
                      'data': _.canMockLocation ? 'Sim' : 'Não'
                    },
                    {
                      'label': 'Esta armazenado em uma memoria externa?',
                      'data': _.isOnExternalStorage ? 'Sim' : 'Não'
                    },
                    {
                      'label': 'É um dispositivo seguro?',
                      'data': _.isSafeDevice ? 'Sim' : 'Não'
                    },
                    {
                      'label': 'Dispositivo esta no modo desenvolvedor?',
                      'data': _.isDevelopmentModeEnable ? 'Sim' : 'Não'
                    },
                  ]),
                  const SizedBox(height: 20),
                  CardInfo(title: 'Informações do dispositivo', data: [
                    {'label': 'Modelo:', 'data': '${_.deviceData['model']}'},
                    {
                      'label': 'Hardware:',
                      'data': '${_.deviceData['hardware']}'
                    },
                    {
                      'label': 'Tem suporte para 32 bits?',
                      'data': _.deviceData['supported32BitAbis'].isEmpty
                          ? 'Não'
                          : 'Sim'
                    },
                    {
                      'label': 'Tem suporte para 64 bits?',
                      'data': _.deviceData['supported64BitAbis'].isEmpty
                          ? 'Não'
                          : 'Sim'
                    },
                    {'label': 'Host:', 'data': '${_.deviceData['host']}'},
                    {'label': 'Id:', 'data': '${_.deviceData['id']}'},
                    {
                      'label': 'Largura da tela:',
                      'data': '${_.deviceData['widthPx']}'
                    },
                    {
                      'label': 'Altura da tela:',
                      'data': '${_.deviceData['heightPx']}'
                    },
                    {
                      'label': 'Nº de serie:',
                      'data': '${_.deviceData['serialNumber']}'
                    },
                  ]),
                  TextButton(
                      onPressed: () => {_.handleShare(urlImage: _.qrCodeImage)},
                      child: Image.network(
                        _.qrCodeImage,
                      )),
                  TextButton(
                      onPressed: () => {
                            _.handleShare(
                                text:
                                    'https://api.whatsapp.com/send?phone=5521912345678')
                          },
                      child: Text(
                          'https://api.whatsapp.com/send?phone=5521912345678',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.blue[300], fontSize: 16))),
                  ElevatedButton(
                      onPressed: () => {
                            _.handleShare(
                                urlImage: _.qrCodeImage,
                                text:
                                    'https://api.whatsapp.com/send?phone=5521912345678')
                          },
                      child: const Text('Compartilhar link e qr code',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16))),
                ]));
    }));
  }
}

class CardInfo extends StatelessWidget {
  const CardInfo({super.key, required this.data, required this.title});

  final String title;
  final List<Map<String, String>> data;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (_) {
        return Container(
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black)),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Text(title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold))),
                const SizedBox(height: 10),
                ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 5);
                    },
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return TextInfo(
                          label: data[index]['label'],
                          data: data[index]['data']);
                    }),
              ],
            ));
      },
    );
  }
}

class TextInfo extends StatelessWidget {
  const TextInfo({super.key, required this.label, required this.data});

  final String? label;
  final String? data;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (_) {
        return Text(
          "$label $data",
          style: const TextStyle(
            fontSize: 16,
          ),
        );
      },
    );
  }
}
