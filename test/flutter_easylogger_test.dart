import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('adds one to input values', () {
    // var json1 =
    //     "[{\"name\":\"张三\",\"age\":{\"name\":\"张三\",\"age\":18}},{\"name\":\"李四\",\"age\":{\"name\":\"张三\",\"age\":18}},{\"name\":\"王五\",\"age\":{\"name\":\"张三\",\"age\":18}}]";
    // var json2 =
    //     "{\"data\":[{\"name\":\"张三\",\"age\":18},{\"name\":\"李四\",\"age\":20},{\"name\":\"王五\",\"age\":10}]}";
    //
    // Logger.v("object");
    // Logger.d("object", tag: "tag");
    // // Logger.json(json1);
    // Logger.json(json2);
    var nowTime = DateTime.now();
    var hour = nowTime.hour;
    var minute = nowTime.minute;
    var second = nowTime.second;

    print(nowTime);
    // print("$hour - $minute - $second");
    print(DateFormat.format(DateTime.now(),haveDay: true));
    print(DateFormat.format(DateTime.now()));
    // print( DateTime.parse("yyyy-MM-dd HH:mm:ss"));
  });


}

class DateFormat{
  
  static String format(DateTime date,{bool haveDay = false}) {
    StringBuffer buffer = StringBuffer();
    if(haveDay){
      var day =  date.toString().split(" ")[0];
      buffer.write(day);
      buffer.write(" ");
    }
   var time =  date.toString().split(" ")[1].split(".")[0];

    buffer.write(time);
    return buffer.toString();
  }

}
