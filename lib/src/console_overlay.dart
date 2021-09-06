import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easylogger/src/code_overlay.dart';

import 'flutter_logger.dart';
import 'mode/code_show_mode.dart';
import 'mode/log_mode.dart';
import 'logger_printer.dart';
import 'util/console_util.dart';
import 'mode/filter_menu_mode.dart';

class ConsoleOverlay {
  static OverlayEntry? _entry;
  static bool isShow = false;

  static void show(BuildContext context) {
    if (!isShow) {
      _entry = OverlayEntry(builder: (_) {
        return Align(
          alignment: Alignment.topCenter,
          child: Container(
            padding: const EdgeInsets.only(top: 40),
            child: ConsoleOverlayWidget(),
          ),
        );
      });
      Overlay.of(context)?.insert(_entry!);
      isShow = true;
    }
  }

  static remove() {
    if (isShow) {
      _entry?.remove();
    }
    isShow = false;
  }
}

class ConsoleOverlayWidget extends StatefulWidget {
  ConsoleOverlayWidget({Key? key}) : super(key: key);

  @override
  _ConsoleOverlayWidgetState createState() => _ConsoleOverlayWidgetState();
}

class _ConsoleOverlayWidgetState extends State<ConsoleOverlayWidget> {
  final ValueNotifier<FilterMenu> _menuValue =
      ValueNotifier(FilterMenu(10, true));
  final CodeValueNotifier _codeValueNotifier = CodeValueNotifier();
  static const int _logAll = 0;
  static const int _logOnlyFile = 1;
  static const int _logOnlyTime = 2;
  static const double _logHeigh = 210;
  final SizedBox _divider = const SizedBox(
    height: 1,
    width: 80,
    child: Divider(
      color: Colors.black26,
    ),
  );

  late ScrollController _controller;

  late TextEditingController _textController;
  static const int _levelDefault = -1;

  String _filterStr = "";

  int _logLevel = _levelDefault;

  int _logStyle = 0;

  bool _isLarge = false;

  String _levelName = "all";

  double _marginTop = 0;

  final double _mangerSize = 50;

  final GlobalKey _globalKey = GlobalKey();
  final GlobalKey _globalForDrag = GlobalKey();

  double _currendDy = 0;

  @override
  void initState() {
    _controller = ScrollController();
    _textController = TextEditingController();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      RenderBox renderObject =
          _globalKey.currentContext?.findRenderObject() as RenderBox;
      _currendDy = renderObject.localToGlobal(Offset.zero).dy;
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildDraggable();
  }

  Widget _buildDraggable() {
    return LayoutBuilder(builder: (context, constraints) {
      if (_marginTop <= 0) {
        _marginTop = 0;
      }
      return Stack(
        children: [
          Positioned(
            top: _marginTop,
            child: Container(
              key: _globalKey,
              child: Draggable(
                axis: Axis.vertical,
                child: _buildDragView(constraints),
                // _isLarge 的状态下，不准拖动
                feedback: _isLarge ? Container() : _buildDragView(constraints),
                childWhenDragging:
                    _isLarge ? _buildDragView(constraints) : Container(),
                onDragEnd: (DraggableDetails details) {
                  _calculatePosition(details);
                },
              ),
            ),
          ),
        ],
      );
    });
  }

  /// 计算位置
  void _calculatePosition(DraggableDetails details) {
    if (!_isLarge) {
      if (mounted) {
        setState(() {
          _closeKeyBoard();
          double offY = 0;
          if ((details.offset.dy - _currendDy) < 0) {
            offY = 0;
          } else {
            offY = details.offset.dy - _currendDy;
          }
          _marginTop = offY;
        });
      }
    }
  }

  Widget _buildDragView(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth,
      key: _globalForDrag,
      height: _isLarge
          ? constraints.maxHeight + _mangerSize
          : _logHeigh + _mangerSize,
      // 因为滑动的时候 不知道为啥 说  IconButton 需要 Material，暂时不知道，所以加了 Scaffold
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: _isLarge ? constraints.maxHeight - 50 : _logHeigh,
                  color: Colors.black,
                  width: constraints.maxWidth,
                  child: ValueListenableBuilder<LogModeValue>(
                    valueListenable: Logger.notifier,
                    builder: (_, model, child) {
                      return _buildLogWidget(model);
                    },
                  ),
                ),
                Container(
                  height: _mangerSize,
                  width: constraints.maxWidth,
                  color: Colors.black26,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: _clearLog,
                        icon: const Icon(Icons.clear),
                      ),
                      IconButton(
                        onPressed: _changeStyle,
                        icon: const Icon(Icons.style),
                      ),
                      IconButton(
                        onPressed: () {
                          _menuValue.value.isVisible = false;
                          _menuValue.notifyListeners();
                        },
                        icon: const Icon(Icons.print),
                      ),
                      Text(
                        _levelName,
                        style: TextStyle(
                            color: ConsoleUtil.getLevelColor(_logLevel)),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: _buildTextFiled(),
                      ),
                      IconButton(
                        onPressed: _changeSize,
                        icon: Icon(_isLarge
                            ? Icons.crop
                            : Icons.aspect_ratio_outlined),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            _logMenuWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildLogWidget(LogModeValue model) {
    List<LogMode> modeList = model.logModeList;
    List<LogMode> fiterList = [];
    for (int i = modeList.length - 1; i >= 0; i--) {
      LogMode logMode = modeList[i];
      // 过滤日志
      if ((_logLevel == logMode.level || _logLevel == _levelDefault) &&
          logMode.logMessage != null &&
          logMode.logMessage!.contains(_filterStr)) {
        fiterList.add(logMode);
      }
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 2500,
        child: ListView.builder(
          controller: _controller,
          reverse: true,
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            LogMode logMode = fiterList[index];
            TextStyle _logStyle = TextStyle(
                color: ConsoleUtil.getLevelColor(logMode.level),
                fontSize: 15,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.w400);
            String log = _getLog(logMode);
            return InkWell(
              child: Text(log, style: _logStyle),
              onTap: () {
               CodeOverlay.show(context, logMode.fileUri);
              },
            );
          },
          itemCount: fiterList.length,
        ),
      ),
    );
  }

  /// 清除日志
  void _clearLog() {
    _closeKeyBoard();
    Logger.notifier.value = LogModeValue();
  }

  /// 设置log样式，是否显示时间，是否显示文件名
  void _changeStyle() {
    if (mounted) {
      setState(() {
        _logStyle++;
      });
    }
  }

  final List<String> _logLevelFilter = [
    "all",
    "verbose",
    "debug",
    "info",
    "warn",
    "error",
    "取消"
  ];

  Widget _logMenuWidget() {
    return ValueListenableBuilder<FilterMenu>(
        valueListenable: _menuValue,
        builder: (_, model, child) {
          return Positioned(
              left: 80,
              bottom: _isLarge ? 80 : 0,
              child: Offstage(
                offstage: model.isVisible,
                child: Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  elevation: 10,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: _logLevelFilter.map((value) {
                      return Column(
                        children: [
                          SizedBox(
                            height: 30,
                            child: MaterialButton(
                              onPressed: () {
                                filterLog(value);
                              },
                              child: Text(
                                value,
                                style: TextStyle(
                                    color: _levelName == value
                                        ? Colors.blue
                                        : Colors.black87,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                          Offstage(
                              child: _divider, offstage: value.contains("取消")),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ));
        });
  }

  Widget _codeWidget() {
    return ValueListenableBuilder<FilterMenu>(
        valueListenable: _menuValue,
        builder: (_, model, child) {
          return Positioned(
              left: 80,
              bottom: _isLarge ? 80 : 0,
              child: Offstage(
                offstage: model.isVisible,
                child: Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  elevation: 10,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: _logLevelFilter.map((value) {
                      return Column(
                        children: [
                          SizedBox(
                            height: 30,
                            child: MaterialButton(
                              onPressed: () {
                                filterLog(value);
                              },
                              child: Text(
                                value,
                                style: TextStyle(
                                    color: _levelName == value
                                        ? Colors.blue
                                        : Colors.black87,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                          Offstage(
                              child: _divider, offstage: value.contains("取消")),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ));
        });
  }

  /// 过滤log
  void filterLog(String buttonValue) {
    if (buttonValue != "取消") {
      if (mounted) {
        _closeKeyBoard();
        setState(() {
          switch (buttonValue) {
            case "all":
              _logLevel = _levelDefault;
              break;
            case "verbose":
              _logLevel = LoggerPrinter.verbose;
              break;
            case "debug":
              _logLevel = LoggerPrinter.debug;
              break;
            case "info":
              _logLevel = LoggerPrinter.info;
              break;
            case "warn":
              _logLevel = LoggerPrinter.warn;
              break;
            case "error":
              _logLevel = LoggerPrinter.error;
              break;
          }
          _levelName = buttonValue;
        });
      }
    }

    _menuValue.value.isVisible = true;
    _menuValue.notifyListeners();
  }

  /// 更改大小
  void _changeSize() {
    if (mounted) {
      setState(() {
        _closeKeyBoard();
        _isLarge = !_isLarge;
        // 如果是 大 的情况，直接让 top 设置为 0；
        if (_isLarge) {
          _marginTop = 0;
        }
      });
    }
  }

  Widget _buildTextFiled() {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.only(left: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        autofocus: false,
        controller: _textController,
        onChanged: (value) {
          _filterText(value);
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          hintText: "过滤日志",
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _textController.clear();
              _filterText("");
            },
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  /// 过滤log
  void _filterText(String value) {
    setState(() {
      _filterStr = value;
    });
  }

  /// 关闭软键盘，并且取消焦点
  void _closeKeyBoard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    FocusManager.instance.primaryFocus?.unfocus();
  }

  /// 样式
  String _getLog(LogMode logMode) {
    String log = logMode.logMessage ?? "";
    switch (_logStyle % 3) {
      case _logAll:
        log = logMode.logMessage ?? "";
        break;
      case _logOnlyFile:
        log = log.replaceAll(logMode.fileName ?? "", "");
        break;
      case _logOnlyTime:
        log = log.replaceAll(logMode.time ?? "", "");
        break;
    }

    // print(log);
    return log;
  }
}
