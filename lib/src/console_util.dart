import 'package:flutter/material.dart';

import '../logger_printer.dart';
import 'log_mode.dart';

LogValueNotifier notifier = LogValueNotifier();

class ConsoleUtil {
  static Color getLevelColor(int? level) {
    Color color = Colors.white54;
    switch (level) {
      case LoggerPrinter.verbose:
        color= Colors.white54;
        break;
      case LoggerPrinter.debug:
        color= Colors.blue;
        break;
      case LoggerPrinter.info:
        color= Colors.green;

        break;
      case LoggerPrinter.warn:
        color= Colors.yellow;
        break;
      case LoggerPrinter.error:
        color= Colors.redAccent;
        break;
    }
    return color;
  }
}
