语言: [English](https://github.com/niezhiyang/flutter_logger/blob/master/README.md) | 中文简体]

# flutter_logger

在flutter中，简单，漂亮，功能强大的日志打印工具，带有文件名字以及行号，并且可以定制自己的打印日志级别的颜色，按照android中的 [logger](https://github.com/orhanobut/logger) 设计的
## 版本

```
flutter_easylogger: ^{LAST_VERSION}
```

## 简单实用


```
Logger.d("hello");
```

## 打印出来的结果

![](https://github.com/niezhiyang/flutter_logger/blob/master/art/1625751834730.jpg)

## 更多的实用
下面是没有带tag的
```
Logger.v("hello world");
Logger.d("hello world");
Logger.i("hello world");
Logger.w("hello world");
Logger.e("hello world");
var json = "{\"name\":\"tom\",\"age\":\"18\"}";
Logger.json(json);
```
下面是有tag的
```
Logger.d("hello",tag:"TAG");
```
![](https://github.com/niezhiyang/flutter_logger/blob/master/art/tag.jpg)

Json  support (output will be in debug level)
也支持json的打印(json的打印默认是d级别)
```
Logger.json(json);
```

## 更多用法 
你可以定制打印级别的日志颜色，范围是0-255，具体的颜色值参考下面的图片
```
Logger.levelVerbose = 247;
Logger.levelDebug = 26;
Logger.levelInfo = 28;
Logger.levelWarn = 3;
Logger.levelError = 9;
```
![](https://github.com/niezhiyang/flutter_logger/blob/master/art/colors.png)


## 注意
当在生产环境，请关闭打印
```
Logger.enable = false;
```
