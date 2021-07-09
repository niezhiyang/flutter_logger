# flutter_logger

Simple, pretty and powerful logger for flutter，It has the log level, file name and line number, and can customize the color of the log level，It was inspired by [logger](https://github.com/orhanobut/logger)

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



