// coverage: false
// coverage:ignore-file

import 'di.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

/// Service Locator for  project
final sl = GetIt.I;

/// initialization of Service locator
@InjectableInit()
Future<void> configureDependencies() async => sl.init();
