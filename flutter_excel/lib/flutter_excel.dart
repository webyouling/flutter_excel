import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_excel/model/InfoDataEx.dart';
import 'package:permission_handler/permission_handler.dart';

class FlutterExcel {
  static const MethodChannel _channel = const MethodChannel('flutter_excel');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> exportData(List<InfoData> info) async {
    bool permission = await permissionsRequest();
    if (permission) {
      String jsonData = json.encode(info);
      final String exportPath =
          await _channel.invokeMethod('exportData', {'infodata': jsonData});
      return exportPath;
    } else {
      return null;
    }
//    String jsonData = json.encode(info);
//      final String exportPath =
//          await _channel.invokeMethod('exportData', {'infodata': jsonData});
//      return exportPath;
  }

  //权限
  static Future<bool> permissionsRequest() async {
    bool isPermissions = false;
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (permission == PermissionStatus.granted) {
      isPermissions = true;
    } else {
      Map<PermissionGroup, PermissionStatus> permissions =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.storage]);
      if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
        isPermissions = true;
      } else {
        isPermissions = false;
      }
    }
    return isPermissions;
  }
}
