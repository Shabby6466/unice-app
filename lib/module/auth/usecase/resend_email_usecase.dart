import 'package:injectable/injectable.dart';
import 'package:unice_app/core/services/datasources/remote_data_source/remote_data_source.dart';
import 'package:unice_app/core/services/repository/repository.dart';
import 'package:unice_app/core/services/usecases/usecase.dart';

@singleton
class ResendEmailUsecase extends UseCase<ResendEmailInput, bool> {
  final Repository repository;

  ResendEmailUsecase({required this.repository});

  @override
  Future<bool> call(ResendEmailInput params) {
    return repository.resendEmailOtp(params);
  }
}

class ResendEmailInput extends ApiParams {
  final String email;
  final String token;

  ResendEmailInput({
    required this.email,
    required this.token,
  });

  factory ResendEmailInput.withToken({
    required ResendEmailInput params,
    required String token,
  }) =>
      ResendEmailInput(
        email: params.email,
        token: token,
      );

  @override
  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}
