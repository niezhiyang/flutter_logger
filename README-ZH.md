语言: [English](https://github.com/niezhiyang/flutter_logger/blob/master/README.md) | 中文简体]

# flutter_logger

- 在flutter中，简单，漂亮，功能强大的日志打印工具，带有文件名字以及行号，并且可以定制自己的打印日志级别的颜色，按照android中的 [logger](https://github.com/orhanobut/logger) 设计的
级别的颜色 在 ios 上无法修改。
- 同时也可以在手机上输出打印日志，也可以按照日志级别过滤，或者是根据关键词过滤
## 版本

```
flutter_easylogger: ^{LAST_VERSION}
```

## 简单实用


```dart
Logger.d("hello");
```

## 打印出来的结果

![](https://github.com/niezhiyang/flutter_logger/blob/master/art/1625751834730.jpg)

## 更多的实用
下面是没有带tag的
```dart
Logger.v("hello world");
Logger.d("hello world");
Logger.i("hello world");
Logger.w("hello world");
Logger.e("hello world");
var json = "{\"name\":\"tom\",\"age\":\"18\"}";
Logger.json(json);
```
下面是有tag的
```dart
Logger.e("hello",tag:"TAG");
```
![](https://github.com/niezhiyang/flutter_logger/blob/master/art/tag.jpg)

Json  support (output will be in debug level)
也支持json的打印(json的打印默认是d级别)
```dart
Logger.json(json);
```

## 更多用法 
你可以定制打印级别的日志颜色，范围是0-255，具体的颜色值参考下面的图片
```dart
Logger.init(
    true,// 是否打印，在生产环境下，请填写 false
    isShowFile: true, // 在 IDE 中, 是否显示 文件名
    isShowTime: true, // 在 IDE 中, 是否显示 时间
    levelVerbose: 247, // 在 IDE 中, 设置 对应级别的 颜色，请参考下图
    levelDebug: 26,
    levelInfo: 28,
    levelWarn: 3,
    levelError: 3,
    phoneVerbose: Colors.white54, // 在你手机上设置颜色
    phoneDebug: Colors.blue,
    phoneInfo: Colors.green,
    phoneWarn: Colors.yellow,
    phoneError: Colors.redAccent,
  );
```
![](https://github.com/niezhiyang/flutter_logger/blob/master/art/colors.png)


## 手机上打印日志
可以在手机上打印日志，也可以去通过日志级别去过滤，或者是关键词，ConsoleWidget就是打印的 Widget，可以拖动，可以放大
```dart
ConsoleOverlay.show(context);
```
<img src="https://github.com/niezhiyang/flutter_logger/blob/master/art/logger_phone.gif" width="30%">


## 注意
当在生产环境，请关闭打印
```dart
Logger.init(false);
```
|  IOS   |  IOS   | Android| Web  |
|  ----  |  ----  | ----  | ----  |
| ide上颜色  | 不支持  | 支持 | 支持 |
| 手机上颜色  | 支持  | 支持 | 支持 |
## 感谢
[ansicolor-dart](https://github.com/google/ansicolor-dart)<br>
[d_logger](https://github.com/liulianshanzhu/d_logger)<br>
