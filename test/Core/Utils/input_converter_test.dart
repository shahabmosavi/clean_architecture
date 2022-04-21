import 'package:clean_architecture/Core/Utils/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group("stringToUnsignedInteger", () {
    test('should retrun an integer when string represents an unsigned string',
        () async {
      //arrange
      const str = '123';
      //act
      final result = inputConverter.stringToUnSignedInteger(str);
      //assert
      expect(result, const Right(123));
    });
    test(
        'should retrun a Failure when string not represents an unsigned string',
        () async {
      //arrange
      const str = 'abc';
      //act
      final result = inputConverter.stringToUnSignedInteger(str);
      //assert
      expect(result, Left(InvalidInputFailure()));
    });
    test('should retrun a Failure when string is a negative integer', () async {
      //arrange
      const str = '-1';
      //act
      final result = inputConverter.stringToUnSignedInteger(str);
      //assert
      expect(result, Left(InvalidInputFailure()));
    });
  });
}
