import 'package:flutter/material.dart';

import '../flutter_logger.dart';
import '../logger_printer.dart';
import '../mode/log_mode.dart';



class ConsoleUtil {
  static Color getLevelColor(int? level) {
    Color color = Colors.white54;
    switch (level) {
      case LoggerPrinter.verbose:
        color = Logger.verboseColor ?? Colors.white54;
        break;
      case LoggerPrinter.debug:
        color = Logger.debugColor ?? Colors.blue;
        break;
      case LoggerPrinter.info:
        color = Logger.infoColor ?? Colors.green;

        break;
      case LoggerPrinter.warn:
        color = Logger.warnColor ?? Colors.yellow;
        break;
      case LoggerPrinter.error:
        color = Logger.errorColor ?? Colors.redAccent;
        break;
    }
    return color;
  }
}
