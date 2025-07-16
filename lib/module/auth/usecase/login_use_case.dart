import 'package:injectable/injectable.dart';
import 'package:unice_app/core/services/datasources/remote_data_source/remote_data_source.dart';
import 'package:unice_app/core/services/repository/repository.dart';
import 'package:unice_app/core/services/usecases/usecase.dart';
import 'package:unice_app/module/auth/usecase/google_auth_use_case.dart';

@singleton
class LoginEmailUseCase extends UseCase<LoginInput, LoginOutput> {
  final Repository repository;

  LoginEmailUseCase({required this.repository});

  @override
  Future<LoginOutput> call(LoginInput params) {
    return repository.login(params);
  }
}

class LoginInput extends ApiParams {
  final String identifier, password;

  LoginInput({required this.identifier, required this.password});

  @override
  Map<String, dynamic> toJson() {
    return {
      'identifier': identifier,
      'password': password,
    };
  }
}

class LoginOutput {
  final User user;
  final String token;

  LoginOutput({
    required this.user,
    required this.token,
  });

  factory LoginOutput.fromJson(Map<String, dynamic> json) {
    var user = json['user'] != null ? User.fromJson(json['user']) : User.initial();
    var token = json['token'] ?? '';
    return LoginOutput(user: user, token: token);
  }

  factory LoginOutput.initial() => LoginOutput(user: User.initial(), token: '');
}
