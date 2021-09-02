library flutter_logger;

import 'dart:ui';

import 'package:flutter/material.dart';

import 'logger_printer.dart';
import 'printer.dart';
import 'mode/log_mode.dart';

class Logger {
  static LogValueNotifier notifier = LogValueNotifier();

  Logger._getInstance();

  /// 控制是否打印
  static bool _enable = true;

  /// 日志中是否含有文件名字
  static bool _isShowFile = true;

  static bool get isShowFile {
    return _isShowFile;
  }


  /// 日志中是否含 点击 定位到文件的打印位置
  static bool _isShowNavigation = true;

  static bool get isShowNavigation {
    return _isShowNavigation;
  }

  /// 日志中是否含时间
  static bool _isShowTime = true;

  static bool get isShowTime {
    return _isShowTime;
  }

  /// 日志级别颜色配置
  static int _levelVerbose = 247;

  static int get levelVerbose {
    return _levelVerbose;
  }

  static int _levelDebug = 26;

  static int get levelDebug {
    return _levelDebug;
  }

  static int _levelInfo = 28;

  static int get levelInfo {
    return _levelInfo;
  }

  static int _levelWarn = 3;

  static int get levelWarn {
    return _levelWarn;
  }

  static int _levelError = 9;

  static int get levelError {
    return _levelError;
  }

  /// 因为 不知道 ansicolor 对应 16进制的具体颜色，所以单独 拿出来 专门针对 手机上的打印颜色
  static Color? _verboseColor;

  static Color? get verboseColor {
    return _verboseColor;
  }

  static Color? _debugColor;

  static Color? get debugColor {
    return _debugColor;
  }

  static Color? _infoColor;

  static Color? get infoColor {
    return _infoColor;
  }

  static Color? _warnColor;

  static Color? get warnColor {
    return _warnColor;
  }

  static Color? _errorColor;

  static Color? get errorColor {
    return _errorColor;
  }

  /// 获取是否打印
  static bool isEnable() {
    return _enable;
  }

  /// 默认的打印，也可以
  static Printer _printer = LoggerPrinter();

  /// 设置用户自己的打印
  static set printer(Printer _printer) {
    _printer = _printer;
  }

  static void v(Object? object, {String? tag}) {
    _printer.v(object, tag: tag);
  }

  static void d(Object? object, {String? tag}) {
    _printer.d(object, tag: tag);
  }

  static void i(Object? object, {String? tag}) {
    _printer.i(object, tag: tag);
  }

  static void w(Object? object, {String? tag}) {
    _printer.w(object, tag: tag);
  }

  static void e(Object? object, {String? tag}) {
    _printer.e(object, tag: tag);
  }

  /// 打印json
  static void json(String? json, {String? tag}) {
    _printer.json(json, tag: tag);
  }

  // 初始化 Logger，不初始化也能用，只是做一些配置.
  ///
  /// [isEnable] 是否输出日志，在正式环境下请关闭
  /// [levelVerbose] 在 ide 中控制台 Verbose 日志的颜色
  /// [levelDebug] 在 ide 中控制台 Debug 日志的颜色
  /// [levelInfo] 在 ide 中控制台 Info 日志的颜色
  /// [levelWarn] 在 ide 中控制台 Warn 日志的颜色
  /// [levelError] 在 ide 中控制台 Error 日志的颜色
  /// [isShowTime] 在 ide 中控制台 打印日志的时候是否显示时间
  /// [isShowFile] 在 ide 中控制台 打印日志的时候是否显示文件名
  /// [isShowNavigation] 在 ide 中控制台 打印日志的时候是否显示可以定位到打印的具体位置
  ///
  /// 因为 ansi 的颜色 和  16进制的具体颜色 我对应不上，所以添加在手机上时自己添加颜色
  ///
  /// [phoneVerbose] 在 手机上输出时， Verbose 日志的颜色
  /// [phoneDebug] 在 手机上输出时， Debug 日志的颜色
  /// [phoneInfo] 在 手机上输出时， Info 日志的颜色
  /// [phoneWarn] 在 手机上输出时， Warn 日志的颜色
  /// [phoneError] 在 手机上输出时， Error 日志的颜色
  ///
  static void init(
    bool isEnable, {
    bool isShowTime = true,
    bool isShowFile = true,
    bool isShowNavigation = true,
    int levelVerbose = 247,
    int levelDebug = 26,
    int levelInfo = 28,
    int levelWarn = 3,
    int levelError = 9,
    Color phoneVerbose = Colors.white54,
    Color phoneDebug = Colors.blue,
    Color phoneInfo = Colors.green,
    Color phoneWarn = Colors.yellow,
    Color phoneError = Colors.redAccent,
  }) {
    _enable = isEnable;
    _isShowTime = isShowTime;
    _isShowFile = isShowFile;
    _isShowNavigation = isShowNavigation;
    _levelVerbose = levelVerbose;
    _levelDebug = levelDebug;
    _levelInfo = levelInfo;
    _levelWarn = levelWarn;
    _levelError = levelError;
    _verboseColor = phoneVerbose;
    _debugColor = phoneDebug;
    _infoColor = phoneInfo;
    _warnColor = phoneWarn;
    _errorColor = phoneError;
  }
}
