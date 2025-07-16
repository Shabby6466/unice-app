part of 'index.dart';

abstract class HttpApiCalls {
  /// this method is used to call HTTP post request
  Future<Response<dynamic>> onPost({required String api, required dynamic data, Map<String, dynamic>? queryParameters, Map<String, dynamic>? headers, String? jwt});

  /// this method is used to call HTTP put request
  Future<Response<dynamic>> onPut({required String api, required dynamic data, Map<String, dynamic>? queryParameters, Map<String, dynamic>? headers, String? jwt});

  /// this method is used to call HTTP patch request
  Future<Response<dynamic>> onPatch({required String api, required dynamic data, Map<String, dynamic>? queryParameters, Map<String, dynamic>? headers, String? jwt});

  /// this method is used to call HTTP get request
  Future<Response<dynamic>> onGet({required String api, dynamic data, Map<String, dynamic>? queryParameters, Map<String, dynamic>? headers, String? jwt});

  /// this method is used to call HTTP delete request
  Future<Response<dynamic>> onDelete({required String api, Map<String, dynamic>? queryParameters, Map<String, dynamic>? headers, String? jwt, Map<String, dynamic>? data});

  /// this method is used to handle HTTP headers for api calling
  void resolveAPIMetadata({Map<String, dynamic>? queryParameters, Map<String, dynamic>? headers, String? jwt});
}

@LazySingleton(as: HttpApiCalls)
class DioWrapperImpl implements HttpApiCalls {
  final Dio _dio;
  final Logger _logger;
  final ErrorHandler _errorHandler;

  // CustomInterceptors? _interceptor;

  DioWrapperImpl({
    required Dio dio,
    required Logger logger,
    required ErrorHandler errorHandler,
  })  : _dio = dio,
        _logger = logger,
        _errorHandler = errorHandler;

  @override
  Future<Response<dynamic>> onPost({
    required String api,
    required dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    String? jwt,
  }) async {
    try {
      resolveAPIMetadata(queryParameters: queryParameters, headers: headers, jwt: jwt);
      return await _dio.post(api, data: data);
    } on DioException catch (e) {
      _logger.f('[ON POST | DIO ERROR] [API | ${e.requestOptions.baseUrl}$api] ${e.response}');
      if (e.type == DioExceptionType.badResponse) {
        throw _errorHandler.handleStatusCode(e.response?.statusCode ?? 400, e.response?.data['message'] ?? '');
      }
      if (e.type == DioExceptionType.receiveTimeout) {
        throw const TimeoutFailure('Server Timeout');
      }
      throw _errorHandler.throwDefaultFailure();
    } catch (e) {
      _logger.f('[ON POST | SOMETHING GOES WRONG IN API CALL] $e}');
      throw _errorHandler.throwDefaultFailure();
    }
  }

  @override
  Future<Response<dynamic>> onPut({
    required String api,
    required dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    String? jwt,
  }) async {
    try {
      resolveAPIMetadata(queryParameters: queryParameters, headers: headers, jwt: jwt);
      return await _dio.put(api, data: data);
    } on DioException catch (e) {
      _logger.f('[ON PUT | DIO ERROR] [API | $api] ${e.response}');
      if (e.type == DioExceptionType.badResponse) {
        throw _errorHandler.handleStatusCode(e.response?.statusCode ?? 500, e.response?.data['message']);
      }
      throw _errorHandler.throwDefaultFailure();
    } catch (e) {
      _logger.f('[ON PUT | SOMETHING GOES WRONG IN API CALL] $e');
      throw _errorHandler.throwDefaultFailure();
    }
  }

  @override
  Future<Response<dynamic>> onPatch({
    required String api,
    required dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    String? jwt,
  }) async {
    try {
      resolveAPIMetadata(queryParameters: queryParameters, headers: headers, jwt: jwt);
      return await _dio.patch(api, data: data);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        _logger.f('[ON PATCH | DIO ERROR] [API | $api] ${e.response}');
        throw _errorHandler.handleStatusCode(e.response?.statusCode ?? 500, e.response?.data['message']);
      }
      throw _errorHandler.throwDefaultFailure();
    } catch (e) {
      _logger.f('[ON PATCH | SOMETHING GOES WRONG IN API CALL] $e');
      throw _errorHandler.throwDefaultFailure();
    }
  }

  @override
  Future<Response<dynamic>> onGet({
    required String api,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    String? jwt,
  }) async {
    try {
      resolveAPIMetadata(queryParameters: queryParameters, headers: headers, jwt: jwt);
      return await _dio.get(api, data: data);
    } on DioException catch (e) {
      _logger.f('[ON GET | DIO ERROR] [API | $api] ${e.response}');
      if (e.type == DioExceptionType.badResponse) {
        if (e.response?.statusCode == 502) {
          throw _errorHandler.handleStatusCode(502, e.response?.data['detail']);
        }
        throw _errorHandler.handleStatusCode(e.response?.statusCode ?? 500, e.response?.data['message']);
      }
      throw _errorHandler.throwDefaultFailure();
    } catch (e) {
      _logger.f('[ON GET | SOMETHING GOES WRONG IN API CALL] $e');
      throw _errorHandler.throwDefaultFailure();
    }
  }

  @override
  Future<Response<dynamic>> onDelete({
    required String api,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    String? jwt,
    Map<String, dynamic>? data,
  }) async {
    try {
      resolveAPIMetadata(headers: headers, jwt: jwt, queryParameters: queryParameters);
      return await _dio.delete(api, data: data);
    } on DioException catch (e) {
      _logger.f('[ON Delete | DIO ERROR] [API | $api] ${e.response}');
      if (e.type == DioExceptionType.badResponse) {
        throw _errorHandler.handleStatusCode(e.response?.statusCode ?? 500, e.response?.data['message']);
      }
      throw _errorHandler.throwDefaultFailure();
    } catch (e) {
      _logger.f('[ON Delete | SOMETHING GOES WRONG IN API CALL] $e');
      throw _errorHandler.throwDefaultFailure();
    }
  }

  @override
  void resolveAPIMetadata({Map<String, dynamic>? queryParameters, Map<String, dynamic>? headers, String? jwt}) {
    _dio.options.queryParameters.clear();
    if (queryParameters != null) {
      _dio.options.queryParameters.addAll(queryParameters);
    }
    if (headers != null) {
      _dio.options.headers.addAll(headers);
    }
    if (jwt != null) {
      _dio.interceptors.addAll([CustomInterceptors(jwt: jwt, dio: _dio, logger: _logger)]);
    }
  }
}
