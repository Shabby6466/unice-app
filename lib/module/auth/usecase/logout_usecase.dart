import 'package:injectable/injectable.dart';
import 'package:unice_app/core/services/repository/repository.dart';
import 'package:unice_app/core/services/usecases/usecase.dart';

@singleton
class LogoutUsecase extends UseCase<NoParams, bool> {
  final Repository repository;

  LogoutUsecase({required this.repository});

  @override
  Future<bool> call(NoParams params) {
    return repository.logout(params);
  }
}

