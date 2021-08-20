import 'package:flutter/material.dart';

import '../logger_printer.dart';
import 'log_mode.dart';

LogValueNotifier notifier = LogValueNotifier();

class ConsoleUtil {
  ConsoleUtil._getInstance() {}

  static Color? verboseColor;

  static Color? debugColor;

  static Color? infoColor;

  static Color? warnColor;

  static Color? errorColor;

  static Color getLevelColor(int? level) {
    Color color = Colors.white54;
    switch (level) {
      case LoggerPrinter.verbose:
        color = verboseColor ?? Colors.white54;
        break;
      case LoggerPrinter.debug:
        color = debugColor ?? Colors.blue;
        break;
      case LoggerPrinter.info:
        color = infoColor ?? Colors.green;

        break;
      case LoggerPrinter.warn:
        color = warnColor ?? Colors.yellow;
        break;
      case LoggerPrinter.error:
        color = errorColor ?? Colors.redAccent;
        break;
    }
    return color;
  }
}
