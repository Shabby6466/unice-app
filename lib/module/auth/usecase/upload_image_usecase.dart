import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:injectable/injectable.dart';
import 'package:unice_app/core/services/datasources/remote_data_source/remote_data_source.dart';
import 'package:unice_app/core/services/usecases/usecase.dart';
import 'package:unice_app/core/services/repository/repository.dart';

@singleton
class UploadFileUsecase extends UseCase<UploadFileInput, UploadFileOutput> {
  final Repository repository;

  UploadFileUsecase({required this.repository});

  @override
  Future<UploadFileOutput> call(UploadFileInput params) {
    return repository.uploadImage(params);
  }
}

class UploadFileInput extends ApiParams {
  final String filePath;
  final String token;

  UploadFileInput({
    required this.filePath,
    required this.token,
  });

  static final allowedExtensions = ['jpg', 'jpeg', 'png', 'pdf', 'csv'];

  Future<FormData> toFormData() async {
    final file = File(filePath);

    if (!await file.exists()) {
      throw Exception("File does not exist at path: $filePath");
    }

    final extension = file.path.split('.').last.toLowerCase();

    if (!allowedExtensions.contains(extension)) {
      throw Exception("Invalid file format. Allowed: ${allowedExtensions.join(', ')}");
    }

    final mediaType = _getMediaType(extension);

    return FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: file.uri.pathSegments.last,
        contentType: mediaType,
      ),
    });
  }

  MediaType _getMediaType(String extension) {
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');
      case 'png':
        return MediaType('image', 'png');
      case 'pdf':
        return MediaType('application', 'pdf');
      case 'csv':
        return MediaType('text', 'csv');
      default:
        return MediaType('application', 'octet-stream');
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'file': filePath,
    };
  }

  factory UploadFileInput.withToken({
    required UploadFileInput params,
    required String token,
  }) {
    return UploadFileInput(
      filePath: params.filePath,
      token: token,
    );
  }
}

class UploadFileOutput {
  final String url;

  UploadFileOutput({required this.url});

  factory UploadFileOutput.fromJson(Map<String, dynamic> json) {
    return UploadFileOutput(
      url: json['data']['url'] ?? '',
    );
  }

  factory UploadFileOutput.initial() => UploadFileOutput(url: '');
}
