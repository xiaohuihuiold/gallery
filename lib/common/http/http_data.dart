import 'package:gallery/common/http/http_manager.dart';

/// http返回数据
class HttpData<T> {
  /// 地址
  String url;

  /// 方法
  HttpMethod method;

  /// 参数
  dynamic params;

  /// 状态码
  int code;

  /// 状态信息
  String message;

  /// 返回数据
  T data;

  HttpData({
    this.url,
    this.method,
    this.params,
    this.code,
    this.message,
    this.data,
  });

  factory HttpData.copy(HttpData httpData) {
    return HttpData(
      url: httpData?.url,
      method: httpData?.method,
      params: httpData?.params,
      code: httpData?.code,
      message: httpData?.message,
      data: (httpData?.data is T) ? httpData?.data : null,
    );
  }

  factory HttpData.error([String message]) {
    return HttpData(
      code: HttpCode.HTTP_CODE_PROGRAM_ERROR,
      message: HttpCode.getMessage(HttpCode.HTTP_CODE_PROGRAM_ERROR, message),
    );
  }

  @override
  String toString() {
    return '''
========$method========
| url: $url
| params: $params
| code: $code
| message: $message
| data: $data
=======================
    ''';
  }
}

class HttpCode {
  static const HTTP_CODE_METHOD_NOT = -1;
  static const HTTP_CODE_PROGRAM_ERROR = -2;

  static Map<int, String> messages = {
    HTTP_CODE_METHOD_NOT: '请求方法错误',
    HTTP_CODE_PROGRAM_ERROR: '程序出错',
    200: '请求成功',
  };

  static String getMessage(int code, [String message]) {
    return message ?? messages[code] ?? '未知错误';
  }
}
