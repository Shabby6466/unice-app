import 'package:injectable/injectable.dart';
import 'package:unice_app/core/services/datasources/remote_data_source/remote_data_source.dart';
import 'package:unice_app/core/services/repository/repository.dart';
import 'package:unice_app/core/services/usecases/usecase.dart';

@singleton
class ForgotPasswordUseCase extends UseCase<ForgotPasswordInput, ForgotPasswordOutput> {
  final Repository repository;

  ForgotPasswordUseCase({required this.repository});

  @override
  Future<ForgotPasswordOutput> call(ForgotPasswordInput params) {
    return repository.forgotPassword(params);
  }
}

class ForgotPasswordInput extends ApiParams {
  final String email;

  ForgotPasswordInput({required this.email});

  @override
  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}

class ForgotPasswordOutput {
  final int statusCode;
  final String message;
  final Data data;

  ForgotPasswordOutput({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory ForgotPasswordOutput.fromJson(Map<String, dynamic> json) {
    var statusCode = json['statusCode'] ?? 0;
    var message = json['message'] ?? '';
    var data = json['data'] != null ? Data.fromJson(json['data']) : Data.initial();
    return ForgotPasswordOutput(statusCode: statusCode, message: message, data: data);
  }

  factory ForgotPasswordOutput.initial() => ForgotPasswordOutput(statusCode: 0, message: '', data: Data.initial());
}

class Data {
  final String code;

  Data({required this.code});

  factory Data.fromJson(Map<String, dynamic> json) {
    var code = json['code'] ?? '';
    return Data(code: code);
  }

  factory Data.initial() => Data(code: '');
}
