import 'package:flutter_logger/flutter_logger.dart';
import 'package:flutter_logger/src/file_util.dart';

abstract class Printer {


  void v(Object? object, {String? tag});

  void d(Object? object, {String? tag});

  void i(Object? object, {String? tag});

  void w(Object? object, {String? tag});

  void e(Object? object, {String? tag});

  void json(String? json, {String? tag});
}


