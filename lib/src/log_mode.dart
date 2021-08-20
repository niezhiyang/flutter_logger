import 'package:flutter/material.dart';

class LogModeValue {
  List<LogMode> logModeList = [];
}

class LogMode {
  String? logMessage;
  int? level;

  LogMode({this.logMessage, this.level});
}

class LogValueNotifier extends ValueNotifier<LogModeValue> {
  bool _isDispoosed = false;

  LogValueNotifier() : super(LogModeValue());

  void addLog(LogMode mode) {
    value.logModeList.add(mode);
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _isDispoosed = true;
  }

  @override
  void notifyListeners() {
    if (!_isDispoosed) {
      super.notifyListeners();
    }
  }
}
