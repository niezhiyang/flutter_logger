library flutter_logger;

import 'logger_printer.dart';
import 'printer.dart';

class Logger {
  /// 控制是否打印
  static bool _enable = true;

  /// 日志中是否含有文件名字，去掉了 .dart 后缀名
  static bool isShowFile = true;

  /// 日志级别颜色配置
  static int levelVerbose = 247;
  static int levelDebug = 26;
  static int levelInfo = 28;
  static int levelWarn = 3;
  static int levelError = 9;


  /// 设置是否控制打印
  static set enable(bool enable) {
    _enable = enable;
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
}
