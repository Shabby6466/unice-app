import 'package:equatable/equatable.dart';

/// No params class
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}

/// abstract class for Use cases
abstract class UseCase<Input, Output> {
  Future<Output> call(Input params);
}
