import 'dart:convert';

import '../flutter_logger.dart';

class FileUtil {
  /// 拿到当前文件名字
  static String getFile({bool isJson = false}) {
    String traceString = StackTrace.current.toString();
    RegExpMatch? curMatch = RegExp(r'[A-Za-z_]+.dart').firstMatch(traceString);
    Iterable<RegExpMatch> allMatch =
        RegExp(r'[A-Za-z_]+.dart').allMatches(traceString);
    String? fileName = "";
    if (curMatch != null) {
      List<RegExpMatch> stacks = allMatch
          .where((element) => element.group(0) != curMatch.group(0))
          .toList();
      fileName = stacks[isJson ? 4 : 3].group(0);
    }
    return fileName?.split(".")[0] ?? "";
  }

  ///json字符串格式化
  static String jsonFormat(String json) {
    try {
      if (json.startsWith("{")) {
        //is jsonObject
        Map<String, dynamic> decode = const JsonCodec().decode(json);
        return _convert(decode, 0);
      } else if (json.startsWith("[")) {
        //is jsonArray
        List decode = const JsonCodec().decode(json);
        return _convert(decode, 0);
      } else {
        //错误的json格式
        Logger.e("Wrong format: $json");
        return "Wrong format: $json";
      }
    } catch (e) {
      Logger.e("${e.toString().trim()}\njson: $json");
      return "${e.toString().trim()}\njson: $json";
    }
  }

  /// [object]  解析的对象
  /// [deep]  递归的深度，用来获取缩进的空白长度
  /// [isObject] 用来区分当前map或list是不是来自某个字段，则不用显示缩进。单纯的map或list需要添加缩进
  static String _convert(dynamic object, int deep, {bool isObject = false}) {
    var buffer = StringBuffer();
    var nextDeep = deep + 1;
    if (object is Map) {
      var list = object.keys.toList();
      if (!isObject) {
        //如果map来自某个字段，则不需要显示缩进
        buffer.write("${getDeepSpace(deep)}");
      }
      buffer.write("{");
      if (list.isEmpty) {
        //当map为空，直接返回‘}’
        buffer.write("}");
      } else {
        buffer.write("\n");
        for (int i = 0; i < list.length; i++) {
          buffer.write("${getDeepSpace(nextDeep)}\"${list[i]}\":");
          buffer.write(_convert(object[list[i]], nextDeep, isObject: true));
          if (i < list.length - 1) {
            buffer.write(",");
            buffer.write("\n");
          }
        }
        buffer.write("\n");
        buffer.write("${getDeepSpace(deep)}}");
      }
    } else if (object is List) {
      if (!isObject) {
        //如果list来自某个字段，则不需要显示缩进
        buffer.write("${getDeepSpace(deep)}");
      }
      buffer.write("[");
      if (object.isEmpty) {
        //当list为空，直接返回‘]’
        buffer.write("]");
      } else {
        buffer.write("\n");
        for (int i = 0; i < object.length; i++) {
          buffer.write(_convert(object[i], nextDeep));
          if (i < object.length - 1) {
            buffer.write(",");
            buffer.write("\n");
          }
        }
        buffer.write("\n");
        buffer.write("${getDeepSpace(deep)}]");
      }
    } else if (object is String) {
      //为字符串时，需要添加双引号并返回当前内容
      buffer.write("\"$object\"");
    } else if (object is num || object is bool) {
      //为数字或者布尔值时，返回当前内容
      buffer.write(object);
    } else {
      //如果对象为空，则返回null字符串
      buffer.write("null");
    }
    return buffer.toString();
  }

  ///获取缩进空白符
  static String getDeepSpace(int deep) {
    var tab = StringBuffer();
    for (int i = 0; i < deep; i++) {
      tab.write("\t");
    }
    return tab.toString();
  }
}
