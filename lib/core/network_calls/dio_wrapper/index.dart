import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:unice_app/core/di/di.dart';
import 'package:unice_app/core/services/usecases/usecase.dart';
import 'package:unice_app/core/utils/go_router/routes_constant.dart';
import 'package:unice_app/core/utils/go_router/routes_navigation.dart';
import 'package:unice_app/core/utils/utitily_methods/utils.dart';
import 'package:unice_app/module/setting/usecase/logout_use_case.dart';

part 'wrapper_error_handler.dart';
part 'network_call_wrapper.dart';
part 'failures.dart';
