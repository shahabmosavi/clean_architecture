import 'dart:convert';

import 'package:clean_architecture/Features/NumberTrivia/Data/Models/number_trivia_model.dart';
import 'package:clean_architecture/Features/NumberTrivia/Domain/Entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../Fixtures/fixture_reader.dart';

void main() {
  NumberTriviaModel tNumberTriviaModel =
      const NumberTriviaModel(number: 1, text: 'test text');
  test('should be a subclass of NumberTrivia', () async {
    //assert
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });
  group('fromJson', () {
    test('should return a valid model when json number is an integer',
        () async {
      //arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));

      //act
      final NumberTrivia result = NumberTriviaModel.fromJson(jsonMap);
      //assert
      expect(result, tNumberTriviaModel);
    });
    test('should return a valid model when json number is regarded as double',
        () async {
      //arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('trivia_double.json'));

      //act
      final NumberTriviaModel result = NumberTriviaModel.fromJson(jsonMap);
      //assert
      expect(result, tNumberTriviaModel);
    });
  });
  group('fromJson', () {
    test('should return a json map containing the proper data', () async {
      //act
      final Map<String, dynamic> result = tNumberTriviaModel.toJson();
      //assert
      final Map<String, dynamic> expectedMap = {
        "text": "test text",
        "number": 1.0
      };
      expect(result, expectedMap);
    });
  });
}
