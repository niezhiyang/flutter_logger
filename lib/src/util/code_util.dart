import 'dart:developer';

import 'package:flutter_easylogger/src/util/isolate_util.dart';
import 'package:vm_service/utils.dart';
import 'package:vm_service/vm_service.dart';
import 'package:vm_service/vm_service_io.dart';

class CodeUtil {
  static VmService? _service;

  static Future<VmService> getVMService() async {
    if (_service != null) {
      return _service!;
    }
    ServiceProtocolInfo info = await Service.getInfo();
    String url = info.serverUri.toString();
    // url = url.replaceAll("127.0.0.1", "0.0.0.0");
    // url = url.replaceAll("127.0.0.1", "172.16.149.86");
    Uri uri = Uri.parse(url);
    Uri socketUri = convertToWebSocketUrl(serviceProtocolUrl: uri);
    _service = await vmServiceConnectUri(socketUri.toString());
    return _service!;
  }

  static Future<ScriptList> getScripts() async {
    VmService service = await getVMService();
    return service.getScripts(IsolateUtil.currentId());
  }

  static Future<String?> getClassId(String className) async {
      VmService service = await getVMService();
      final scriptsList = await service.getScripts(IsolateUtil.currentId());

      final scripts = scriptsList.scripts!;

      for (final script in scripts) {
        if (script.uri!.contains(className)) return script.id;
      }

    return null;
  }

 static Future<String?> getCode(String? className) async {
    if(className == null){
      return null;
    }
    var classId = await getClassId(className);
    var service = await getVMService();
    var script = await service.getObject(
      IsolateUtil.currentId(),
      classId??"",
    );
    if (script is Script) {
      return script.source;
    }
    return null;
  }
}
