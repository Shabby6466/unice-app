part of 'index.dart';

abstract class ErrorHandler {
  /// this method is used to handle server exception status code
  Failure handleStatusCode(int internalCode, String message);

  /// this method is use to return failure
  Failure throwDefaultFailure();
}

@LazySingleton(as: ErrorHandler)
class ErrorHandlerImpl extends ErrorHandler {
  @override
  Failure handleStatusCode(int internalCode, String message) {
    switch (internalCode) {
      case 400:
        return DefaultFailure(message);
        case 401:
          sl<Navigation>().go(Routes.loginIndex);
        return DefaultFailure(message);

      default:
        if (message.toString().toLowerCase().contains('expired') && message.toString().toLowerCase().contains('token') || (message.toLowerCase().contains('not found'))) {
          sl<LogoutUseCase>().call(NoParams());
          sl<Navigation>().go(Routes.splash);
          return const DefaultFailure('Something went wrong, Please Login.');
        }
        return DefaultFailure(message);
    }
  }

  @override
  Failure throwDefaultFailure() {
    return const DefaultFailure('something_went_wrong');
  }
}

class CustomInterceptors extends Interceptor {
  final String jwt;
  final Logger logger;
  final Dio dio;

  CustomInterceptors({
    required this.jwt,
    required this.dio,
    required this.logger,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Authorization'] = 'Bearer $jwt';
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }
}
