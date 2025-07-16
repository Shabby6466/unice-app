import 'package:injectable/injectable.dart';
import 'package:unice_app/core/services/datasources/remote_data_source/remote_data_source.dart';
import 'package:unice_app/core/services/repository/repository.dart';
import 'package:unice_app/core/services/usecases/usecase.dart';
import 'package:unice_app/module/auth/usecase/google_auth_use_case.dart';

@singleton
class AppleLoginUseCase extends UseCase<AppleLoginInput, GoogleAuthOutputs> {
  final Repository repository;

  AppleLoginUseCase({required this.repository});

  @override
  Future<GoogleAuthOutputs> call(AppleLoginInput params) {
    return repository.appleLogin(params);
  }
}

class AppleLoginInput extends ApiParams {
  final String idToken;
  final String firstName;
  final String lastName;

  AppleLoginInput({
    required this.idToken,
    required this.firstName,
    required this.lastName,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'idToken': idToken,
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}