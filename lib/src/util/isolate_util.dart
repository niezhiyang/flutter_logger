import 'dart:developer';
import 'dart:isolate';

class IsolateUtil {
  static String currentId() {
    return Service.getIsolateID(Isolate.current)!;
  }
  static Isolate currentIsolate() {
    return Isolate.current;
  }
}
