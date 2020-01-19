import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:gallery/common/http/http_data.dart';

/// http请求方法
enum HttpMethod {
  GET,
  POST,
}

/// http管理器
class HttpManager {
  static HttpManager _instance;

  factory HttpManager() {
    _instance ??= HttpManager._internal();
    return _instance;
  }

  Dio _dio;

  HttpManager._internal() {
    _dio = Dio();
  }

  /// 拉取http数据
  ///
  /// [url] 请求地址
  /// [method] 请求方法
  Future<HttpData> fetch({
    @required String url,
    HttpMethod method = HttpMethod.GET,
    dynamic params,
  }) async {
    Response response;
    try {
      switch (method) {
        case HttpMethod.GET:
          response = await _dio.get(
            url,
            queryParameters: params ?? {},
          );
          break;
        case HttpMethod.POST:
          response = await _dio.post(
            url,
            data: params ?? {},
          );
          break;
        default:
          break;
      }
    } on DioError catch (e) {
      // dio错误
      return HttpData(
        url: url,
        method: method,
        params: params,
        code: e.response?.statusCode,
        message: HttpCode.getMessage(
          e.response?.statusCode,
          e.response?.statusMessage ?? e.toString(),
        ),
        data: null,
      );
    } catch (e) {
      // 其它错误
      return HttpData(
        url: url,
        method: method,
        params: params,
        code: HttpCode.HTTP_CODE_PROGRAM_ERROR,
        message: HttpCode.getMessage(
          HttpCode.HTTP_CODE_PROGRAM_ERROR,
          e.toString(),
        ),
        data: null,
      );
    }
    // 请求方法错误
    if (response == null) {
      return HttpData(
        url: url,
        method: method,
        params: params,
        code: HttpCode.HTTP_CODE_METHOD_NOT,
        message: HttpCode.getMessage(HttpCode.HTTP_CODE_METHOD_NOT, '请求方法错误'),
        data: null,
      );
    }
    // 正常返回
    return HttpData(
      url: url,
      method: method,
      params: params,
      code: response.statusCode,
      message: HttpCode.getMessage(response.statusCode, response.statusMessage),
      data: response.data,
    );
  }
}
