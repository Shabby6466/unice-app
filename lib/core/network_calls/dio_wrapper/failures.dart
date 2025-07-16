part of 'index.dart';

/// these classes are use for different level of errors in app
abstract class Failure extends Equatable implements Exception {
  final String message;

  const Failure(this.message);
}

class DefaultFailure extends Failure {
  const DefaultFailure(super.message);

  @override
  List<Object?> get props => [message];
}

class KycRequiredFailure extends Failure {
  const KycRequiredFailure(super.message);

  @override
  List<Object?> get props => [message];
}

class InvalidCredentialFailure extends Failure {
  const InvalidCredentialFailure(super.message);

  @override
  List<Object?> get props => [message];
}

class EmailNotVerifiedFailure extends Failure {
  const EmailNotVerifiedFailure(super.message);

  @override
  List<Object?> get props => [message];
}

class InvalidEmail extends Failure {
  const InvalidEmail(super.message);

  @override
  List<Object?> get props => [message];
}

class InvalidEmailOrPassword extends Failure {
  const InvalidEmailOrPassword(super.message);

  @override
  List<Object?> get props => [message];
}

class EmailAlreadyExists extends Failure {
  const EmailAlreadyExists(super.message);

  @override
  List<Object?> get props => [message];
}

class SomethingWentWrong extends Failure {
  const SomethingWentWrong(super.message);

  @override
  List<Object?> get props => [message];
}

class SameEmailAlreadyExist extends Failure {
  const SameEmailAlreadyExist(super.message);

  @override
  List<Object?> get props => [message];
}

class CodeExpireFailure extends Failure {
  const CodeExpireFailure(super.message);

  @override
  List<Object?> get props => [message];
}

class UserWithEmailNotExist extends Failure {
  const UserWithEmailNotExist(super.message);

  @override
  List<Object?> get props => [message];
}

class CantResendInThreeMinutes extends Failure {
  const CantResendInThreeMinutes(super.message);

  @override
  List<Object?> get props => [message];
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);

  @override
  List<Object?> get props => [message];
}

class DynamicLinkFailure extends Failure {
  const DynamicLinkFailure(super.message);

  @override
  List<Object?> get props => [message];
}

class InvalidToken extends Failure {
  const InvalidToken(super.message);

  @override
  List<Object?> get props => [message];
}

class TimeoutFailure extends Failure {
  const TimeoutFailure(super.message);

  @override
  List<Object?> get props => [message];
}

class CannotDeleteFailure extends Failure {
  const CannotDeleteFailure(super.message);

  @override
  List<Object?> get props => [message];
}

class EmailNotRegisteredFailure extends Failure {
  const EmailNotRegisteredFailure(super.message);

  @override
  List<Object?> get props => [message];
}

class UserDisabledFailure extends Failure {
  const UserDisabledFailure(super.message);

  @override
  List<Object?> get props => [message];
}

class FcmTokenRetrivalError extends Failure {
  const FcmTokenRetrivalError(super.message);

  @override
  List<Object?> get props => [message];
}

// AccessToken  Failure
class FcmTokenDeletionError extends Failure {
  const FcmTokenDeletionError(super.message);

  @override
  List<Object?> get props => [message];
}

class InvalidFileFormat extends Failure {
  const InvalidFileFormat(super.message);

  @override
  List<Object?> get props => [message];
}

class FileTooBigFailure extends Failure {
  const FileTooBigFailure(super.message);

  @override
  List<Object?> get props => [message];
}

class UnableToPickImage implements Exception {}
