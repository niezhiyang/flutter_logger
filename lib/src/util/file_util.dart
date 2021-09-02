import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import '../flutter_logger.dart';
import '../mode/log_mode.dart';

class LoggerUtil {
  /// 拿到当前文件名字 和 行号
  static String getFileInfo() {
    String fileStr = "";
    try {
      String traceString = StackTrace.current.toString().split("\n")[4];

      int indexOfFileName = traceString.indexOf(RegExp(r'[A-Za-z_1-9]+.dart'));

      String fileInfo = traceString.substring(indexOfFileName);
      String fileName = "";
      String lineNumber = "";
      // 先考虑 android ios 以及 web
      if (traceString.contains("#")) {
        // 代表 android 或者 ios
        List<String> listOfInfos = fileInfo.split(":");
        fileName = listOfInfos[0];
        lineNumber = listOfInfos[1];
      } else {
        // web
        traceString = StackTrace.current.toString().split("\n")[5];
        int indexOfFileName =
        traceString.indexOf(RegExp(r'[A-Za-z_1-9]+.dart'));
        String fileInfo = traceString.substring(indexOfFileName);
        fileName = fileInfo.split(" ")[0];
        lineNumber = fileInfo.split(" ")[1].split(":")[0];
      }

      fileStr = "[$fileName, $lineNumber]";
    } catch (e) {
      // NoThing
    }


    return fileStr;
  }

  static String getNavigationFile() {
    String fileStr = "";
    try {
      String traceString = StackTrace.current.toString().split("\n")[4];
      int indexOfFileName = traceString.indexOf(
          RegExp(r'[A-Za-z_1-9/:1-9]+.dart'));
      if (traceString.contains("#")) {
        fileStr = traceString.substring(indexOfFileName);
      } else {
        // web
        traceString = StackTrace.current.toString().split("\n")[5];
        int indexOfFileName = traceString.indexOf(
            RegExp(r'[A-Za-z_1-9/:1-9]+.dart'));
        fileStr = traceString.substring(indexOfFileName);
        var strList = fileStr.split(" ");
        fileStr =
            "${strList[0]}:${strList[1]})".replaceAll("packages/", "package:");
      }
    } catch (e) {
      // NoThing
    }
    return fileStr;
  }

  static String getFileUri() {
    String fileStr = "";
    try {
      String traceString = StackTrace.current.toString().split("\n")[4];
      int indexOfFileName = traceString.indexOf(
          RegExp(r'[A-Za-z_1-9/:1-9]+.dart'));
      if (traceString.contains("#")) {
        fileStr = traceString.substring(indexOfFileName);
      } else {
        // web
        traceString = StackTrace.current.toString().split("\n")[5];
        int indexOfFileName = traceString.indexOf(
            RegExp(r'[A-Za-z_1-9/:1-9]+.dart'));
        fileStr = traceString.substring(indexOfFileName);
        var strList = fileStr.split(" ");
        fileStr =
            "${strList[0]}:${strList[1]})".replaceAll("packages/", "package:");
      }

      fileStr =  "${fileStr.split(":")[0]}:${fileStr.split(":")[1]}";
    } catch (e) {
      // NoThing
    }
    return fileStr;
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

  ///获取缩进空白符　不能用\t , \t 虽然在android stuido 上可以，但是在安卓和ios上行不通
  static String getDeepSpace(int deep) {
    var tab = StringBuffer();
    for (int i = 0; i < deep; i++) {
      tab.write("　");
      // tab.write("\t");
    }
    return tab.toString();
  }

  static String format(DateTime date, {bool haveDay = false}) {
    StringBuffer buffer = StringBuffer();
    if (haveDay) {
      var day = date.toString().split(" ")[0];
      buffer.write(day);
      buffer.write(" ");
    }
    var time = date.toString().split(" ")[1].split(".")[0];

    buffer.write(time);
    return buffer.toString();
  }

  static String formatDate(DateTime? date, {bool haveDay = true}) {
    StringBuffer buffer = StringBuffer();
    try {
      if (haveDay) {
        var day = date.toString().split(" ")[0];
        buffer.write(day);
        buffer.write(" ");
      }
      var time = date.toString().split(" ")[1].split(".")[0];

      buffer.write(time);
    } catch (e) {
      // do
    }
    return buffer.toString();
  }



}