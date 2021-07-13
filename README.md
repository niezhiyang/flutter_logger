# flutter_logger

Simple, pretty and powerful logger for flutter，It has the log level, file name and line number, and can customize the color of the log level，It was inspired by [logger](https://github.com/orhanobut/logger)

## Download

```
flutter_easylogger: ^{LAST_VERSION}
```

## Usage


```
Logger.d("hello");
```

## Output

![](https://github.com/niezhiyang/flutter_logger/blob/master/art/1625751834730.jpg)

## Options
no tag 
```
Logger.v("hello world");
Logger.d("hello world");
Logger.i("hello world");
Logger.w("hello world");
Logger.e("hello world");
var json = "{\"name\":\"tom\",\"age\":\"18\"}";
Logger.json(json);
```
with tag
```
Logger.d("hello",tag:"TAG");
```
![](https://github.com/niezhiyang/flutter_logger/blob/master/art/tag.jpg)

Json  support (output will be in debug level)
```
Logger.json(json);
```

## Advanced 
You can change the color of level, and the value is in the range of 0-255. Please refer to the picture below for details<br>
![](https://github.com/niezhiyang/flutter_logger/blob/master/art/colors.png)
```
Logger.levelVerbose = 247;
Logger.levelDebug = 26;
Logger.levelInfo = 28;
Logger.levelWarn = 3;
Logger.levelError = 9;
```

## Note
Turn off logging when production
```
Logger.enable = false;
```
