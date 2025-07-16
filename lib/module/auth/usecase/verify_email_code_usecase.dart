import 'package:injectable/injectable.dart';
import 'package:unice_app/core/services/datasources/remote_data_source/remote_data_source.dart';
import 'package:unice_app/core/services/repository/repository.dart';
import 'package:unice_app/core/services/usecases/usecase.dart';

@singleton
class VerifyEmailCodeUseCase extends UseCase<VerifyEmailInput, bool> {
  final Repository repository;

  VerifyEmailCodeUseCase({required this.repository});

  @override
  Future<bool> call(VerifyEmailInput params) {
    return repository.verifyEmail(params);
  }
}

class VerifyEmailInput extends ApiParams {
  final String email;
  final String code;
  final String token;

  VerifyEmailInput({
    required this.email,
    required this.code,
    required this.token,
  });

  factory VerifyEmailInput.withToken({
    required VerifyEmailInput params,
    required String token,
  }) =>
      VerifyEmailInput(
        email: params.email,
        code: params.code,
        token: token,
      );

  @override
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'code': code,
    };
  }
}
