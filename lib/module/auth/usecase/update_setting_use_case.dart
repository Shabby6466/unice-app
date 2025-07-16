import 'package:injectable/injectable.dart';
import 'package:unice_app/core/services/datasources/remote_data_source/remote_data_source.dart';
import 'package:unice_app/core/services/repository/repository.dart';
import 'package:unice_app/core/services/usecases/usecase.dart';

@singleton
class UpdateSettingUseCase extends UseCase<UpdateSettingInput, bool> {
  final Repository repository;

  UpdateSettingUseCase({required this.repository});

  @override
  Future<bool> call(UpdateSettingInput params) {
    return repository.updateSetting(params);
  }
}

class UpdateSettingInput extends ApiParams {
  final bool friendRecommendationEnabled;
  final bool isMatchingEnabled;
  final String token;

  UpdateSettingInput({
    required this.friendRecommendationEnabled,
    required this.isMatchingEnabled,
    required this.token,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'friendRecommendationEnabled': friendRecommendationEnabled,
      'isMatchingEnabled': isMatchingEnabled,
    };
  }

  factory UpdateSettingInput.withToken({required UpdateSettingInput params, required String token}) => UpdateSettingInput(
        token: token,
        friendRecommendationEnabled: params.friendRecommendationEnabled,
        isMatchingEnabled: params.isMatchingEnabled,
      );
}
