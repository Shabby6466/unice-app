import 'package:injectable/injectable.dart';
import 'package:unice_app/core/services/datasources/remote_data_source/remote_data_source.dart';
import 'package:unice_app/core/services/repository/repository.dart';
import 'package:unice_app/core/services/usecases/usecase.dart';

@singleton
class GoogleAuthUseCase extends UseCase<GoogleAuthInput, GoogleAuthOutputs> {
  final Repository repository;

  GoogleAuthUseCase({required this.repository});

  @override
  Future<GoogleAuthOutputs> call(GoogleAuthInput params) {
    return repository.googleAuth(params);
  }
}

class GoogleAuthInput extends ApiParams {
  final String email;

  GoogleAuthInput({required this.email});

  @override
  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}

class GoogleAuthOutputs {
  final User user;
  final String token;

  GoogleAuthOutputs({
    required this.user,
    required this.token,
  });

  factory GoogleAuthOutputs.fromJson(Map<String, dynamic> json) {
    var user = json['user'] != null ? User.fromJson(json['user']) : User.initial();
    var token = json['token'] ?? '';
    return GoogleAuthOutputs(user: user, token: token);
  }

  factory GoogleAuthOutputs.initial() => GoogleAuthOutputs(user: User.initial(), token: '');
}

class User {
  final String id;
  final String email;
  final String username;
  final String phoneNumber;
  final String password;
  final String gender;
  final int age;
  final bool friendRecommendationEnabled;
  final String googleId;
  final bool isEmailVerified;
  final bool isActive;
  final String authProvider;
  final String createdAt;
  final String updatedAt;
  final Profile profile;
  final String friendshipStatus;
  final String friendshipId;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.phoneNumber,
    required this.password,
    required this.gender,
    required this.age,
    required this.friendRecommendationEnabled,
    required this.googleId,
    required this.isEmailVerified,
    required this.isActive,
    required this.authProvider,
    required this.createdAt,
    required this.updatedAt,
    required this.profile,
    required this.friendshipStatus,
    required this.friendshipId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    var id = json['id'] ?? '';
    var email = json['email'] ?? '';
    var username = json['username'] ?? '';
    var phoneNumber = json['phoneNumber'] ?? '';
    var password = json['password'] ?? '';
    var gender = json['gender'] ?? '';
    var age = json['age'] ?? 0;
    var friendRecommendationEnabled = json['friendRecommendationEnabled'] ?? false;
    var googleId = json['googleId'] ?? '';
    var isEmailVerified = json['isEmailVerified'] ?? false;
    var isActive = json['isActive'] ?? false;
    var authProvider = json['authProvider'] ?? '';
    var createdAt = json['createdAt'] ?? '';
    var updatedAt = json['updatedAt'] ?? '';
    var profile = json['profile'] != null ? Profile.fromJson(json['profile']) : Profile.initial();
    var friendshipStatus = json['friendshipStatus'] ?? '';
    var friendshipId = json['friendshipId'] ?? '';
    return User(
      id: id,
      email: email,
      username: username,
      phoneNumber: phoneNumber,
      password: password,
      gender: gender,
      age: age,
      friendRecommendationEnabled: friendRecommendationEnabled,
      googleId: googleId,
      isEmailVerified: isEmailVerified,
      isActive: isActive,
      authProvider: authProvider,
      createdAt: createdAt,
      updatedAt: updatedAt,
      profile: profile,
      friendshipStatus: friendshipStatus,
      friendshipId: friendshipId,
    );
  }

  factory User.initial() => User(
        id: '',
        email: '',
        username: '',
        phoneNumber: '',
        password: '',
        gender: '',
        age: 0,
        friendRecommendationEnabled: false,
        googleId: '',
        isEmailVerified: false,
        isActive: false,
        authProvider: '',
        createdAt: '',
        updatedAt: '',
        profile: Profile.initial(),
        friendshipStatus: '',
        friendshipId: '',
      );
}

class Profile {
  final String profilePicture;
  final String name;
  final String dateOfBirth;

  Profile({
    required this.profilePicture,
    required this.name,
    required this.dateOfBirth,
  });

  factory Profile.initial() => Profile(profilePicture: '', name: '', dateOfBirth: '');

  factory Profile.fromJson(Map<String, dynamic> json) {
    var profilePicture = json['profilePicture'] ?? '';
    var name = json['name'] ?? '';
    var dateOfBirth = json['dateOfBirth'] ?? '';
    return Profile(profilePicture: profilePicture, name: name, dateOfBirth: dateOfBirth);
  }
}
