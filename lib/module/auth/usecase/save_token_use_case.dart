import 'package:injectable/injectable.dart';
import 'package:unice_app/core/services/repository/repository.dart';
import 'package:unice_app/core/services/usecases/usecase.dart';

@singleton
class SaveTokenUseCase extends UseCase<String, bool> {
  final Repository repository;

  SaveTokenUseCase({required this.repository});

  @override
  Future<bool> call(String params) {
    return repository.saveToken(params);
  }
}
