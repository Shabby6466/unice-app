import 'package:injectable/injectable.dart';
import 'package:unice_app/core/services/datasources/remote_data_source/remote_data_source.dart';
import 'package:unice_app/core/services/repository/repository.dart';
import 'package:unice_app/core/services/usecases/usecase.dart';
import 'package:unice_app/module/auth/usecase/google_auth_use_case.dart';

@singleton
class RegisterUseCase extends UseCase<RegisterInput, RegisterOutput> {
  final Repository repository;

  RegisterUseCase({required this.repository});

  @override
  Future<RegisterOutput> call(RegisterInput params) {
    return repository.register(params);
  }
}

class RegisterInput extends ApiParams {
  final String email, username, password, gender, phoneNumber;
  final String? referralCode;
  final String token;
  final int age;
  final bool friendRecommendationEnabled;

  RegisterInput(
      {required this.email,
      this.referralCode,
      required this.username,
      required this.token,
      required this.password,
      required this.gender,
      required this.phoneNumber,
      required this.age,
      required this.friendRecommendationEnabled});

  @override
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
      'password': password,
      'referralCode': referralCode,
      'gender': gender,
      'phoneNumber': phoneNumber,
      'age': age,
      'friendRecommendationEnabled': friendRecommendationEnabled,
    };
  }

  factory RegisterInput.withReferralCode({required RegisterInput params, required String token}) {
    return RegisterInput(
      email: params.email,
      username: params.username,
      password: params.password,
      token: token,
      gender: params.gender,
      phoneNumber: params.phoneNumber,
      age: params.age,
      friendRecommendationEnabled: params.friendRecommendationEnabled,
      referralCode: params.referralCode,
    );
  }
}

class RegisterOutput {
  final User user;
  final String token;

  RegisterOutput({
    required this.user,
    required this.token,
  });

  factory RegisterOutput.fromJson(Map<String, dynamic> json) {
    var user = json['user'] != null ? User.fromJson(json['user']) : User.initial();
    var token = json['token'] ?? '';
    return RegisterOutput(user: user, token: token);
  }

  factory RegisterOutput.initial() => RegisterOutput(user: User.initial(), token: '');
}
