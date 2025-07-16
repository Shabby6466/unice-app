import 'package:injectable/injectable.dart';
import 'package:unice_app/core/services/repository/repository.dart';
import 'package:unice_app/core/services/usecases/usecase.dart';

@singleton
class GetTokenUseCase extends UseCase<NoParams, String> {
  final Repository repository;

  GetTokenUseCase({required this.repository});

  @override
  Future<String> call(NoParams params) {
    return repository.getAuthToken(params);
  }
}

