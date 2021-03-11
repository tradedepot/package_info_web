library package_info_web;

import 'dart:convert';
import 'dart:html';

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:http/http.dart';

/// The web implementation of [PackageInfoPlatform].
///
/// This class implements the `package:package_info_plus` functionality for the web.
class PackageInfoPlugin {
  /// Registers this class as the default instance of [PackageInfoPlatform].
  static void registerWith(Registrar registrar) {
    final channel = MethodChannel(
      'plugins.flutter.io/package_info',
      const StandardMethodCodec(),
      registrar,
    );

    final instance = PackageInfoPlugin();
    channel.setMethodCallHandler(instance.handleMethodCall);
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'getAll':
        return getAll();
    }
  }

  Future<Map<String, dynamic>> getAll() async {
    final url =
        '${Uri.parse(window.document.baseUri).removeFragment()}version.json';

    final response = await get(url);
    final versionMap = _getVersionMap(response);

    return {
      'appName': versionMap['app_name'],
      'packageName': '',
      'version': versionMap['version'],
      'buildNumber': versionMap['build_number'] ?? '',
    };
  }

  Map<String, dynamic> _getVersionMap(Response response) {
    if (response.statusCode == 200) {
      try {
        return jsonDecode(response.body);
      } catch (_) {
        return <String, dynamic>{};
      }
    } else {
      print('not found');
      return <String, dynamic>{};
    }
  }
}
