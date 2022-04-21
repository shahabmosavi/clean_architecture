import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  String message();
  final List properties = const <dynamic>[];
  @override
  List<Object?> get props => [properties];
}

class ServerFailure extends Failure {
  @override
  String message() {
    return 'Server Failure';
  }
}

class CacheFailure extends Failure {
  @override
  String message() {
    return 'Cache Failure';
  }
}
