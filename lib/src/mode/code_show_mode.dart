import 'package:flutter/material.dart';

class CodeVisibleMode {
  bool isVisible = true;
  String fileUri = "";
}

class CodeValueNotifier extends ValueNotifier<CodeVisibleMode> {
  bool _isDispoosed = false;

  CodeValueNotifier() : super(CodeVisibleMode());

  void setVisible(bool visible){
    value.isVisible = visible;
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
