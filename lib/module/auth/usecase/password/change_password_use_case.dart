import 'package:injectable/injectable.dart';
import 'package:unice_app/core/services/datasources/remote_data_source/remote_data_source.dart';
import 'package:unice_app/core/services/repository/repository.dart';
import 'package:unice_app/core/services/usecases/usecase.dart';

@singleton
class ChangePasswordUseCase extends UseCase<ChangePasswordInput, ChangePasswordOutput> {
  final Repository repository;

  ChangePasswordUseCase({required this.repository});

  @override
  Future<ChangePasswordOutput> call(ChangePasswordInput params) {
    return repository.changePassword(params);
  }
}

class ChangePasswordInput extends ApiParams {
  final String currentPassword;
  final String newPassword, token;

  ChangePasswordInput({
    required this.currentPassword,
    required this.newPassword,
    required this.token,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    };
  }

  factory ChangePasswordInput.withToken({required ChangePasswordInput params, required String token}) {
    return ChangePasswordInput(
      currentPassword: params.currentPassword,
      newPassword: params.newPassword,
      token: token,
    );
  }
}

class ChangePasswordOutput {
  final String message;

  ChangePasswordOutput({required this.message});

  factory ChangePasswordOutput.fromJson(Map<String, dynamic> json) {
    return ChangePasswordOutput(
      message: json['message'] ?? '',
    );
  }

  factory ChangePasswordOutput.initial() => ChangePasswordOutput(message: '');
}
