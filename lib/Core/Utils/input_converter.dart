import '../Error/faliure.dart';
import 'package:dartz/dartz.dart';

class InputConverter {
  Either<Failure, int> stringToUnSignedInteger(String str) {
    try {
      final integer = int.parse(str);
      if (integer < 0) {
        throw const FormatException();
      }
      return Right(integer);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {
  @override
  String message() {
    return 'Invalid Input - the number must be a positive integer or zero';
  }
}
