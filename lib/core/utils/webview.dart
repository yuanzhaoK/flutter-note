import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'bridge/js_bridge.dart';

class MyWebView {
  final String url;
  final String title;
  WebKitWebViewController controller; // 添加一个controller
  final WebKitWebViewPermissionRequest? privacyProtocolDialog;

  MyWebView({
    required this.url,
    required this.title,
    required this.controller,
    required this.privacyProtocolDialog,
  });

  @override
  WebViewState createState() => WebViewState();
}

class WebViewState {}
