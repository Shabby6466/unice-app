// coverage: false
// coverage:ignore-file

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:unice_app/core/utils/base_env.dart';

/// this class is use to generate code for initializing dio package when code start
@module
abstract class DioModule {
  final BaseEnv _baseEnv = BaseEnv.instance;

  @lazySingleton
  Dio get dio => Dio(
        BaseOptions(
          baseUrl: _baseEnv.url,
          receiveTimeout: const Duration(milliseconds: 60000),
          connectTimeout: const Duration(milliseconds: 60000),
          sendTimeout: const Duration(milliseconds: 60000),
        ),
      );
}
