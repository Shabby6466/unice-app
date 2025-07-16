import 'package:injectable/injectable.dart';
import 'package:unice_app/core/services/datasources/remote_data_source/remote_data_source.dart';
import 'package:unice_app/core/services/repository/repository.dart';
import 'package:unice_app/core/services/usecases/usecase.dart';

@singleton
class ResetPasswordUseCase extends UseCase<ResetPasswordInput, ResetPasswordOutput> {
  final Repository repository;

  ResetPasswordUseCase({required this.repository});

  @override
  Future<ResetPasswordOutput> call(ResetPasswordInput params) {
    return repository.resetPassword(params);
  }
}

class ResetPasswordInput extends ApiParams {
  final String token;
  final String password;
  final String code;

  ResetPasswordInput({
    required this.token,
    required this.password,
    required this.code,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'password': password,
      'code': code,
    };
  }
}

class ResetPasswordOutput {
  final String message;

  ResetPasswordOutput({required this.message});

  factory ResetPasswordOutput.fromJson(Map<String, dynamic> json) {
    return ResetPasswordOutput(
      message: json['message'] ?? '',
    );
  }

  factory ResetPasswordOutput.initial() => ResetPasswordOutput(message: '');
}
