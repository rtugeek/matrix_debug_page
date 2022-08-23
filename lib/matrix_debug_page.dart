// Flutter imports:
import 'dart:io';
import 'dart:ui';

import 'package:clipboard/clipboard.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'matrix_effect.dart';

// Project imports:

class MatrixDebugPage extends StatefulWidget {
  final String? extraInfo;
  final Map<String, VoidCallback?>? customButtons;

  const MatrixDebugPage({Key? key, this.extraInfo, this.customButtons})
      : super(key: key);

  @override
  State<MatrixDebugPage> createState() => _MatrixDebugPageState();
}

class _MatrixDebugPageState extends State<MatrixDebugPage> {
  var info = "";

  void getInfoString(BuildContext context) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    var sb = StringBuffer("");
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      sb.writeln(
          'Version: ${androidInfo.version.codename}/${androidInfo.version.release}/${androidInfo.version.sdkInt}');
      sb.writeln('Brand: ${androidInfo.brand}');
      sb.writeln('Device: ${androidInfo.device}');
      sb.writeln('Manufacturer: ${androidInfo.manufacturer}');
      sb.writeln('Product: ${androidInfo.product}');
      sb.writeln('Model: ${androidInfo.model}');
      // sb.writeln('Size: ${ScreenUtil().screenWidth}x${ScreenUtil().screenHeight}');
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      sb.writeln('App Version:${packageInfo.version}');
      sb.writeln('Build Number:${packageInfo.buildNumber}');
    }
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      sb.writeln('Model: ${iosDeviceInfo.model}');
      sb.writeln('Name: ${iosDeviceInfo.name}');
      sb.writeln('OS Name: ${iosDeviceInfo.systemName}');
      sb.writeln('OS Version: ${iosDeviceInfo.systemVersion}');

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      sb.writeln('App Version:${packageInfo.version}');
      sb.writeln('Build Number:${packageInfo.buildNumber}');
    }
    if (Platform.isWindows) {
      var winDeviceInfo = await deviceInfo.windowsInfo;
      sb.writeln('Memory: ${winDeviceInfo.systemMemoryInMegabytes}MB');
      sb.writeln('Computer Name: ${winDeviceInfo.computerName}');
      sb.writeln('Core Number: ${winDeviceInfo.numberOfCores}');
    }

    var width = WidgetsBinding.instance.window.physicalSize.width;
    var height = WidgetsBinding.instance.window.physicalSize.height;
    sb.writeln('Windows Size: ${width.round()}x${height.round()}');
    if (widget.extraInfo != null && widget.extraInfo != "") {
      sb.writeln(widget.extraInfo);
    }

    info = sb.toString();
    FlutterClipboard.copy(info);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getInfoString(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          MatrixEffect(),
          Container(
            width: 300,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
                color: Color(0xFF3F3F3F),
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: SizedBox(
              width: 300,
              child: Wrap(
                direction: Axis.vertical,
                runSpacing: 8,
                spacing: 8,
                children: [
                  const Text(
                    "已复制以下信息：",
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    info,
                    style: const TextStyle(color: Colors.green),
                  ),
                  ...generateCustomButton(),
                  // buildButton("发送文字", () {
                  //   Methods.shareText(info);
                  // }),
                  // buildButton("发送文件", () {
                  //   Methods.shareDebugFile();
                  // }),
                  buildButton("返回", () {
                    Navigator.pop(context);
                  }),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Container buildButton(String title, VoidCallback? press) {
    return Container(
      width: 268,
      decoration:
          BoxDecoration(border: Border.all(color: Colors.green, width: 1)),
      child: TextButton(
          onPressed: press,
          child: Text(
            title,
            style: const TextStyle(color: Colors.green),
          )),
    );
  }

  List<Widget> generateCustomButton() {
    List<Widget> buttons = [];
    widget.customButtons?.forEach((key, value) {
      buttons.add(buildButton(key, value));
    });
    return buttons;
  }
}
