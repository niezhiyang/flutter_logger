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
## jumps to the printed file details page
![](https://github.com/niezhiyang/flutter_logger/blob/master/art/click.jpg)

## Advanced 
```dart
Logger.init(
    true,// isEnable ，if production ，please false
    isShowFile: true, // In the IDE, whether the file name is displayed
    isShowTime: true, // In the IDE, whether the time is displayed
    isShowNavigation: true, // In the IDE, When clicked, it jumps to the printed file details page
    levelVerbose: 247, // In the IDE, Set the color
    levelDebug: 26,
    levelInfo: 28,
    levelWarn: 3,
    levelError: 9,
    phoneVerbose: Colors.white54, // In your phone or web，, Set the color
    phoneDebug: Colors.blue,
    phoneInfo: Colors.green,
    phoneWarn: Colors.yellow,
    phoneError: Colors.redAccent,
  );
```
You can change the color of level, and the value is in the range of 0-255. Please refer to the picture below for details<br>
![](https://github.com/niezhiyang/flutter_logger/blob/master/art/colors.png)

## print on the phone
Logs can be printed on the phone or filtered by log level or keyword

<img src="https://github.com/niezhiyang/flutter_logger/blob/master/art/logger_phone.gif" width="30%">

```dart
ConsoleOverlay.show(context);
```
## Note

Turn off logging when production
```dart
Logger.init(false);
```
|  IOS   |  IOS   | Android| Web  |
|  ----  |  ----  | ----  | ----  |
| ide color  | no  | yes | yes |
| phone color  | yes  | yes | yes |