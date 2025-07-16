import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class JsBridge {
  static const String channelName = 'flutter_bridge';

  String method; // 方法名
  Map params; // 参数
  String callback; // 回调函数名

  JsBridge({
    required this.method,
    required this.params,
    required this.callback,
  });

  /// jsonEncode方法中会调用实体类的这个方法。如果实体类中没有这个方法，会报错。
  // 实现jsonEncode方法中会调用实体类的toJSON方法
  Map toJson() {
    Map map = new Map();
    map["method"] = this.method;
    map["params"] = this.params;
    map["callback"] = this.callback;
    return map;
  }

  // 将JS传过来的JSON字符串转换成MAP,然后初始化Model实例
  static JsBridge fromMap(Map<String, dynamic> map) {
    JsBridge bridge = JsBridge(
      method: map['method'],
      params: map['params'],
      callback: map['callback'],
    );
    return bridge;
  }

  @override
  String toString() {
    return "JsBridge: {method: $method, params: $params, callback: $callback}";
  }
}

class JsSDK {
  static late WebKitWebViewController controller;

  // 格式化参数
  static JsBridge? parseJson(String jsonStr) {
    try {
      return JsBridge.fromMap(jsonDecode(jsonStr));
    } catch (e) {
      print(e);
      return null;
    }
  }

  static String toast(context, JsBridge jsBridge) {
    String msg = jsBridge.params['message'] ?? '';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    return 'success'; // 接口返回值，会透传给JS注册的回调函数
  }

  static void executeMethod(
    BuildContext context,
    WebKitWebViewController controller,
    String message,
  ) {
    // 根据JSON字符串构造JSModel对象，
    var model = JsSDK.parseJson(message);
    // 然后执行model对应方法
    var handlers = {
      // test toast
      'toast': () {
        return JsSDK.toast(context, model!);
      },
      // 调用callJS上的方法
      'checkGoBack': () {
        return controller
            .runJavaScriptReturningResult('window.callJS.goBack()')
            .then((value) {
              return value == '1' ? 'can go back' : 'cannot go back';
            })
            .catchError((e) {
              print(e);
            });
      },
    };
    // 运行method对应方法实现
    var method = model?.method;
    dynamic result;
    if (handlers.containsKey(method)) {
      try {
        result = handlers[method]!();
      } catch (e) {
        print(e);
      }
    } else {
      print('无$method对应接口实现');
    }

    // 统一处理JS注册的回调函数
    if (model?.callback != null) {
      var callback = model?.callback;
      void runCallBack(res) {
        var resultStr = jsonEncode(res?.toString() ?? '');
        controller.runJavaScriptReturningResult("$callback($resultStr);");
      }

      if (result is Future) {
        result.then((value) {
          print(value);
          runCallBack(value);
        });
      } else {
        runCallBack(result);
      }
    }
  }
}
