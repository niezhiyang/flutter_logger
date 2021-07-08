import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_logger/flutter_logger.dart';

void main() {
  test('adds one to input values', () {
    var json1 = "[{\"name\":\"张三\",\"age\":{\"name\":\"张三\",\"age\":18}},{\"name\":\"李四\",\"age\":{\"name\":\"张三\",\"age\":18}},{\"name\":\"王五\",\"age\":{\"name\":\"张三\",\"age\":18}}]";
    var json2 = "{\"data\":[{\"name\":\"张三\",\"age\":18},{\"name\":\"李四\",\"age\":20},{\"name\":\"王五\",\"age\":10}]}";

    Logger.d("object");
    // Logger.v("object");
    // Logger.d("object",tag:"tag");
    // // Logger.json(json1);
    // Logger.json(json2);

  });
}
