import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DocOnlineSDKLauncher{

  static const MethodChannel _docOnlineSDkChannel = MethodChannel('DocOnlineSDK/launcher');

  static Future<void> openDocOnlineSdk(Map<String, dynamic> requestData, Map<String, dynamic> responseData) async {
    try {
        await _docOnlineSDkChannel.invokeMethod('openDocOnlineSDK', {
          'requestObject': jsonEncode(requestData),
          'responseObject': jsonEncode(responseData),
        });
    } catch (e) {
      debugPrint("SDK Launch Error: $e");
    }
  }
}