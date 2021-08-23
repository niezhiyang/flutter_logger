import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easylogger/logger_printer.dart';

import 'src/console_util.dart';
import 'src/log_mode.dart';

class ConsoleWidget extends StatefulWidget {
  ConsoleWidget({Key? key}) : super(key: key);

  @override
  _ConsoleWidgetState createState() => _ConsoleWidgetState();
}

class _ConsoleWidgetState extends State<ConsoleWidget> {
  late ScrollController _controller;

  late TextSelectionControls _selectionControl;

  late TextEditingController _textController;
  static const int _levelDefault = -1;

  String _filterStr = "";

  int _logLevel = _levelDefault;
  bool _isLarge = false;

  String _levelName = "all";

  double _marginTop = 0;

  final double _mangerSize = 50;

  final GlobalKey _globalKey = GlobalKey();
  final GlobalKey _globalForDrag = GlobalKey();

  double _currendDy = 0;
  double _mostEndDy = 0;

  @override
  void initState() {
    _controller = ScrollController();
    _selectionControl = MaterialTextSelectionControls();
    _textController = TextEditingController();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      RenderBox renderObject =
          _globalKey.currentContext?.findRenderObject() as RenderBox;
      _currendDy = renderObject.localToGlobal(Offset.zero).dy;

      _mostEndDy = MediaQuery.of(context).size.height -
          context.size!.height -
          renderObject.localToGlobal(Offset.zero).dy;
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
      return Container(
        key: _globalKey,
        margin: EdgeInsets.only(top: _marginTop),
        child: Draggable(
          axis: Axis.vertical,
          child: _buildDragView(constraints),
          // 因为当软件盘打开的时候，并且是展开的时候，移动会有问题，但是Draggable又不支持不移动，所以做的下面这个
          feedback: _isLarge ? Container() : _buildDragView(constraints),
          // 因为当软件盘打开的时候，并且是展开的时候，移动会有问题，但是Draggable又不支持不移动，所以做的下面这个
          childWhenDragging: _isLarge ? _buildDragView(constraints) : Container(),
          onDragEnd: (DraggableDetails details) {
            if (!_isLarge) {
              setState(() {
                _closeKeyBoard();
                double offY = 0;
                if (details.offset.dy - _currendDy < 0) {
                  offY = 0;
                } else if (details.offset.dy - _currendDy > _mostEndDy) {
                  offY = _mostEndDy;
                } else {
                  offY = details.offset.dy - _currendDy;
                }
                _marginTop = offY;
              });
            }
          },
        ),
      );
    });
  }

  Widget _buildDragView(BoxConstraints constraints) {
    // 防止软键盘，导致溢出
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      key: _globalForDrag,
      child: Container(
        width: constraints.maxWidth,
        height: _isLarge
            ? constraints.maxHeight - 100 + _mangerSize
            : 200 + _mangerSize,
        // 因为滑动的时候 不知道为啥 说  IconButton 需要 Material，暂时不知道，所以加了 Scaffold
        child: Scaffold(
          body: Column(
            children: [
              Container(
                height: _isLarge ? constraints.maxHeight - 100 : 200,
                color: Colors.black,
                width: constraints.maxWidth,
                child: ValueListenableBuilder<LogModeValue>(
                  valueListenable: notifier,
                  builder: (BuildContext context, LogModeValue model,
                      Widget? child) {
                    return _buildLogWidget(model);
                  },
                ),
              ),
              Container(
                height: _mangerSize,
                width: constraints.maxWidth,
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
                      icon: Icon(
                          _isLarge ? Icons.crop : Icons.aspect_ratio_outlined),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogWidget(LogModeValue model) {
    List<TextSpan> spanList = [];
    List<LogMode> modeList = model.logModeList;
    for (int i = modeList.length - 1; i >= 0; i--) {
      LogMode logMode = modeList[i];
      TextStyle _logStyle = TextStyle(
          color: ConsoleUtil.getLevelColor(logMode.level),
          fontSize: 15,
          // fontFamily: 'monospace',
          decoration: TextDecoration.none,
          fontWeight: FontWeight.w400);

      // TextStyle _logStyle =GoogleFonts.oxygenMono(color: ConsoleUtil.getLevelColor(logMode.level),);
      TextSpan span = TextSpan(
        children: [
          TextSpan(
            text: "${logMode.logMessage}\n",
            style: _logStyle,
          ),
        ],
      );
      // 过滤日志
      if ((_logLevel == logMode.level || _logLevel == _levelDefault) &&
          logMode.logMessage != null &&
          logMode.logMessage!.contains(_filterStr)) {
        spanList.add(span);
      }
    }

    return Scrollbar(
      // controller: _controller,
      scrollbarOrientation: ScrollbarOrientation.bottom,

      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(8.0),
        primary: true,
        child: SelectableText.rich(
          TextSpan(
            children: spanList,
          ),
          selectionControls: _selectionControl,
        ),
      ),
    );
  }

  /// 清除日志
  void _clearLog() {
    _closeKeyBoard();
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
      _closeKeyBoard();
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
        _closeKeyBoard();
        _isLarge = !_isLarge;
        // 如果是 大 的情况，直接让 top 设置为 0；
        if (_isLarge) {
          _marginTop = 0;
        }
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

  Widget _buildTextFiled() {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: EdgeInsets.only(left: 15),
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
}
