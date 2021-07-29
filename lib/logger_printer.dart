
import 'dart:io';

import 'flutter_logger.dart';
import 'printer.dart';
import 'src/ansicolor.dart';
import 'src/file_util.dart';

class LoggerPrinter extends Printer {
  static const int _verbose = 1;
  static const int _debug = 2;
  static const int _info = 3;
  static const int _warn = 4;
  static const int _error = 5;

  static const String _topLeft = '┌';
  static const String _bottomLeft = '└';
  static const String _topRight = '┐';
  static const String _bottomRight = '┘';
  static const String _verticalLine = '│';
  static const String _divider =
      "────────────────────────────────────────────────────────";
  static const String _topBorder = "$_topLeft$_divider$_divider$_topRight";
  static const String _bottomBorder =
      "$_bottomLeft$_divider$_divider$_bottomRight";

  @override
  void v(Object? object, {String? tag}) {
    log(_verbose, object, tag);
  }

  @override
  void d(Object? object, {String? tag}) {
    log(_debug, object, tag);
  }

  @override
  void i(Object? object, {String? tag}) {
    log(_info, object, tag);
  }

  @override
  void w(Object? object, {String? tag}) {
    log(_warn, object, tag);
  }

  @override
  void e(Object? object, {String? tag}) {
    log(_error, object, tag);
  }

  @override
  void json(String? json, {String? tag}) {
    if (json != null) {
      log(_debug, FileUtil.jsonFormat(json), tag);
    }
  }

  void log(int level, Object? object, String? tag, {bool isJson = false}) {
    if (ansiColorDisabled) {
      ansiColorDisabled = false;
    }
    if (object == null || object.toString().isEmpty || !Logger.isEnable()) {
      return;
    }
    String message = object.toString();
    AnsiPen pen = getAnsiPen(level);

    String fileName = FileUtil.getFileInfo();

    String prefix =
        "${getLevelFirst(level)}${Logger.isShowFile ? fileName : ""} : ${tag ?? ""}";

    // 绘制开始时上边的分割线
    if (!Platform.isAndroid){
      ansiColorDisabled =true;
    }
    print("${pen.call("$prefix $_topBorder")}");

    // 处理有换行符的，比如说json
    List<String> lines = message.split("\n");

    for (String element in lines) {
      print("${pen.call("$prefix $_verticalLine $element")}");
    }

    // 绘制结束时下边的分割线
    print("${pen.call("$prefix $_bottomBorder")}");
  }

  AnsiPen getAnsiPen(int level) {
    AnsiPen pen = AnsiPen();
    switch (level) {
      case _verbose:
        pen.xterm(Logger.levelVerbose);
        break;
      case _debug:
        pen.xterm(Logger.levelDebug);
        break;
      case _info:
        pen.xterm(Logger.levelInfo);
        break;
      case _warn:
        pen.xterm(Logger.levelWarn);
        break;
      case _error:
        pen.xterm(Logger.levelError);
        break;
    }
    return pen;
  }

  String getLevelFirst(int level) {
    String firstLevelChat = "";
    switch (level) {
      case _verbose:
        firstLevelChat = "V/";
        break;
      case _debug:
        firstLevelChat = "D/";
        break;
      case _info:
        firstLevelChat = "I/";
        break;
      case _warn:
        firstLevelChat = "W/";

        break;
      case _error:
        firstLevelChat = "E/";
        break;
    }
    return firstLevelChat;
  }
}
