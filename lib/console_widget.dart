import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_easylogger/logger_printer.dart';

import 'src/console_util.dart';
import 'src/log_mode.dart';

class ConsoleWidget extends StatefulWidget {
  ConsoleWidget({Key? key}) : super(key: key);

  @override
  _ConsoleWidgetState createState() => _ConsoleWidgetState();
}

class _ConsoleWidgetState extends State<ConsoleWidget> {
  static const int _levelDefault = -1;

  int _logLevel = _levelDefault;
  bool _isLarge = false;

  String _levelName = "all";

  // final Color _curreetLeveColor = ConsoleUtil.getLevelColor(_logLevel);

  final double _mangerSize = 40;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          Container(
            height:
                _isLarge ? constraints.biggest.height - _mangerSize - 100 : 200,
            width: constraints.biggest.width,
            color: Colors.black,
            child: ValueListenableBuilder<LogModeValue>(
              valueListenable: notifier,
              builder:
                  (BuildContext context, LogModeValue model, Widget? child) {
                return _getChild(model);
              },
            ),
          ),
          Container(
            height: _mangerSize,
            width: constraints.biggest.width,
            color: Colors.grey,
            child: Row(
              children: [
                IconButton(
                  onPressed: _clearLog,
                  icon: Icon(Icons.clear),
                ),
                IconButton(
                  onPressed: _showCupertinoActionSheet,
                  icon: Icon(Icons.print),
                ),
                Text(
                  _levelName,
                  style: TextStyle(color: ConsoleUtil.getLevelColor(_logLevel)),
                ),
                const Expanded(
                  child: Text(""),
                ),
                IconButton(
                  onPressed: _changeSize,
                  icon:
                      Icon(_isLarge ? Icons.crop : Icons.aspect_ratio_outlined),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _getChild(LogModeValue model) {
    List<TextSpan> spanList = [];
    List<LogMode> modeList = model.logModeList;
    for (int i = modeList.length - 1; i >= 0; i--) {
      LogMode logMode = modeList[i];
      TextStyle _logStyle = TextStyle(
          color: ConsoleUtil.getLevelColor(logMode.level),
          fontSize: 15,
          decoration: TextDecoration.none,
          fontWeight: FontWeight.w400);

      TextSpan span = TextSpan(
        children: [
          TextSpan(
            text: "${logMode.logMessage}\n",
            style: _logStyle,
          ),
        ],
      );
      if (_logLevel == logMode.level || _logLevel == _levelDefault) {
        spanList.add(span);
      }
    }

    return Scrollbar(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SelectableText.rich(
            TextSpan(
              children: spanList,
            ),
          ),
        ),
      ),
    );
  }

  /// 清除日志
  void _clearLog() {
    notifier.value = LogModeValue();
  }

  /// 过滤日志
  Future _showCupertinoActionSheet() async {
    var result = await showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            title: const Text('提示'),
            message: const Text('选择过滤日志级别？'),
            actions: [
              CupertinoActionSheetAction(
                child: const Text('清除过滤'),
                onPressed: () {
                  filterLog(context, _levelDefault);
                },
                isDefaultAction: _logLevel != _levelDefault,
                isDestructiveAction: _logLevel == _levelDefault,
              ),
              CupertinoActionSheetAction(
                child: const Text('verbose'),
                onPressed: () {
                  filterLog(context, LoggerPrinter.verbose);
                },
                isDefaultAction: _logLevel != LoggerPrinter.verbose,
                isDestructiveAction: _logLevel == LoggerPrinter.verbose,
              ),
              CupertinoActionSheetAction(
                child: const Text('debug'),
                onPressed: () {
                  filterLog(context, LoggerPrinter.debug);
                },
                isDefaultAction: _logLevel != LoggerPrinter.debug,
                isDestructiveAction: _logLevel == LoggerPrinter.debug,
              ),
              CupertinoActionSheetAction(
                child: const Text('info'),
                onPressed: () {
                  filterLog(context, LoggerPrinter.info);
                },
                isDefaultAction: _logLevel != LoggerPrinter.info,
                isDestructiveAction: _logLevel == LoggerPrinter.info,
              ),
              CupertinoActionSheetAction(
                child: const Text('warn'),
                onPressed: () {
                  filterLog(context, LoggerPrinter.warn);
                },
                isDefaultAction: _logLevel != LoggerPrinter.warn,
                isDestructiveAction: _logLevel == LoggerPrinter.warn,
              ),
              CupertinoActionSheetAction(
                child: const Text('error'),
                onPressed: () {
                  filterLog(context, LoggerPrinter.error);
                },
                isDestructiveAction: _logLevel == LoggerPrinter.error,
                isDefaultAction: _logLevel != LoggerPrinter.error,
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop('cancel');
              },
            ),
          );
        });
  }

  /// 过滤log
  void filterLog(BuildContext context, int level) {
    if (mounted) {
      setState(() {
        _logLevel = level;
        _setLevelName();
      });
    }
    Navigator.of(context).pop('delete');
  }

  /// 更改大小
  void _changeSize() {
    if (mounted) {
      setState(() {
        _isLarge = !_isLarge;
        _setLevelName();
      });
    }
  }

  /// 得到当前的名字
  void _setLevelName() {
    switch (_logLevel) {
      case _levelDefault:
        _levelName = "all";
        break;
      case LoggerPrinter.verbose:
        _levelName = "verbose";
        break;
      case LoggerPrinter.debug:
        _levelName = "debug";
        break;
      case LoggerPrinter.info:
        _levelName = "info";
        break;
      case LoggerPrinter.warn:
        _levelName = "warn";
        break;
      case LoggerPrinter.error:
        _levelName = "error";
        break;
    }
  }
}
