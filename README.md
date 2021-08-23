Language: English | [中文简体](https://github.com/niezhiyang/flutter_logger/blob/master/README-ZH.md)

# flutter_logger

- Simple, pretty and powerful logger for flutter，It has the log level, file name and line number, and can customize the color of the log level，It was inspired by [logger](https://github.com/orhanobut/logger)
，Color not supported on ios。
- It can be printed on the phone, and logs can be filtered
## Download

```
flutter_easylogger: ^{LAST_VERSION}
```

## Usage


```dart
Logger.d("hello");
```

## Output

![](https://github.com/niezhiyang/flutter_logger/blob/master/art/1625751834730.jpg)

## Options
no tag 
```dart
Logger.v("hello world");
Logger.d("hello world");
Logger.i("hello world");
Logger.w("hello world");
Logger.e("hello world");
var json = "{\"name\":\"tom\",\"age\":\"18\"}";
Logger.json(json);
```
with tag
```dart
Logger.e("hello",tag:"TAG");
```
![](https://github.com/niezhiyang/flutter_logger/blob/master/art/tag.jpg)

Json  support (output will be in debug level)
```dart
Logger.json(json);
```

## Advanced 
```dart
Logger.levelVerbose = 247;
Logger.levelDebug = 26;
Logger.levelInfo = 28;
Logger.levelWarn = 3;
Logger.levelError = 9;
```
You can change the color of level, and the value is in the range of 0-255. Please refer to the picture below for details<br>
![](https://github.com/niezhiyang/flutter_logger/blob/master/art/colors.png)

## print on the phone
Logs can be printed on the phone or filtered by log level or keyword
![](https://github.com/niezhiyang/flutter_logger/blob/master/art/logger_phone.gif)
```dart
Column(
  children: [
    Expanded(
      // add ConsoleWidget 
      child: ConsoleWidget(),
    )
  ],
),
```
## Note
Turn off logging when production
```
Logger.enable = false;
```