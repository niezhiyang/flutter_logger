import 'package:flutter/material.dart';
import 'package:flutter_easylogger/console_widget.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_easylogger/log_mode.dart';
import 'package:flutter_easylogger/logger_printer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  void onPressed() {
    Logger.v("hello world");
    Logger.d("hello world");
    Logger.i("hello world");
    Logger.w("hello world");
    Logger.e("hello world", tag: "TAG");
    var json =
        "{\"name\":\"tom\",\"age\":\"38\",\"son\":{\"name\":\"jerry\",\"age\":\"18\",\"grandson\":{\"name\":\"lily\",\"age\":\"8\"}}}";
    Logger.json(json);

    Logger.levelVerbose = 247;
    Logger.levelDebug = 26;
    Logger.levelInfo = 28;
    Logger.levelWarn = 3;
    Logger.levelError = 9;

    Logger.verboseColor = Colors.white54;
    Logger.debugColor = Colors.blue;
    Logger.infoColor = Colors.green;
    Logger.warnColor = Colors.yellow;
    Logger.errorColor = Colors.redAccent;
    // 自己添加日志，打印到手机上的，比如说一些错误。
    Logger.notifier
        .addLog(LogMode(logMessage: "我是build错误", level: LoggerPrinter.error));

    // Logger.enable = false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Logger"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: onPressed,
          child: Icon(Icons.add),
        ),
        body: Column(
          children: [
            Expanded(
              child: ConsoleWidget(),
            )
          ],
        ),
      ),
    );
  }
}
