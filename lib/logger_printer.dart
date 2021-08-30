import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_easylogger/log_mode.dart';

import 'flutter_logger.dart';
import 'printer.dart';
import 'src/ansicolor.dart';
import 'src/console_util.dart';
import 'src/file_util.dart';

class LoggerPrinter extends Printer {
  static const int verbose = 1;
  static const int debug = 2;
  static const int info = 3;
  static const int warn = 4;
  static const int error = 5;

  static const String _topLeft = '┌';
  static const String _bottomLeft = '└';
  static const String _topRight = '┐';
  static const String _bottomRight = '┘';
  static const String _verticalLine = '│';
  static const String _divider =
      "────────────────────────────────────────────────────────";

  /// 当需要点击调转到某个文件的时候添加
  static const String _singleDivider =
      "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄";

  //  暂时发现 在 macOs 上 ，应用内，上面的几个都 识别不了
  static const String _verticalLineMacOs = '| ';
  static const String _dividerMacOs =
      "——————————————————————————————————————————————————————";

  //  暂时发现 在 ios 上 ，应用内 _verticalLine 有空格，所以替换成这个
  static const String _verticalLineIos = '｜';

  static const String _topBorder = "$_topLeft$_divider$_divider$_topRight";
  static const String _bottomBorder =
      "$_bottomLeft$_divider$_divider$_bottomRight";

  @override
  void v(Object? object, {String? tag}) {
    log(verbose, object, tag);
  }

  @override
  void d(Object? object, {String? tag}) {
    log(debug, object, tag);
  }

  @override
  void i(Object? object, {String? tag}) {
    log(info, object, tag);
  }

  @override
  void w(Object? object, {String? tag}) {
    log(warn, object, tag);
  }

  @override
  void e(Object? object, {String? tag}) {
    log(error, object, tag);
  }

  @override
  void json(String? json, {String? tag}) {
    if (json != null) {
      log(debug, LoggerUtil.jsonFormat(json), tag);
    }
  }

  void log(int level, Object? object, String? tag, {bool isJson = false}) {
    ansiColorDisabled = false;

    if (object == null || object.toString().isEmpty || !Logger.isEnable()) {
      return;
    }
    String message = object.toString();
    AnsiPen pen = getAnsiPen(level);

    String fileName = LoggerUtil.getFileInfo();
    DateTime dateTime = DateTime.now();
    String time = LoggerUtil.formatDate(dateTime);
    String prefix =
        "${getLevelFirst(level)}${Logger.isShowTime ? dateTime : ""} ${Logger.isShowFile ? fileName : ""} : ${tag ?? ""}";
    String prefixForPhone = "$time $fileName : ${tag ?? ""}";

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      // 在ios平台，ide ，ansi颜色识别不了
      ansiColorDisabled = true;
    }

    // 绘制开始时上边的分割线
    StringBuffer logMessage = StringBuffer();

    print(pen.call("$prefix $_topBorder"));

    if (Logger.isShowNavigation) {
      print("${pen.call("$prefix $_verticalLine")} ${LoggerUtil.getNavigationFile()} ");
      print(pen.call("$prefix $_verticalLine$_singleDivider$_singleDivider"));
    }

    if (defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.windows) {
      logMessage.write("$prefixForPhone $_dividerMacOs\n");
    } else {
      logMessage.write("$prefixForPhone $_topBorder\n");
    }

    // 处理有换行符的，比如说json
    List<String> lines = message.split("\n");

    for (String element in lines) {
      print(pen.call("$prefix $_verticalLine $element"));
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        //主要是运行在ios手机上的 日志， 因为运行在ios上会有不等宽的字符，随意加宽一个空格，
        logMessage.write("$prefixForPhone $_verticalLineIos $element\n");
      } else if (defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.windows) {
        logMessage.write("$prefixForPhone $_verticalLineMacOs $element\n");
      } else {
        logMessage.write("$prefixForPhone $_verticalLine $element\n");
      }
    }

    // 绘制结束时下边的分割线
    print(pen.call("$prefix $_bottomBorder"));

    if (defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.windows) {
      logMessage.write("$prefixForPhone $_dividerMacOs\n");
    } else {
      logMessage.write("$prefixForPhone $_bottomBorder");
    }

    LogMode mode = LogMode(
      level: level,
      fileName: fileName,
      time: time,
      logMessage: logMessage.toString(),
    );
    Logger.notifier.addLog(mode);
  }

  AnsiPen getAnsiPen(int level) {
    AnsiPen pen = AnsiPen();
    switch (level) {
      case verbose:
        pen.xterm(Logger.levelVerbose);
        break;
      case debug:
        pen.xterm(Logger.levelDebug);
        break;
      case info:
        pen.xterm(Logger.levelInfo);
        break;
      case warn:
        pen.xterm(Logger.levelWarn);
        break;
      case error:
        pen.xterm(Logger.levelError);
        break;
    }
    return pen;
  }

  String getLevelFirst(int level) {
    String firstLevelChat = "";
    switch (level) {
      case verbose:
        firstLevelChat = "V/";
        break;
      case debug:
        firstLevelChat = "D/";
        break;
      case info:
        firstLevelChat = "I/";
        break;
      case warn:
        firstLevelChat = "W/";

        break;
      case error:
        firstLevelChat = "E/";
        break;
    }
    return firstLevelChat;
  }
}
