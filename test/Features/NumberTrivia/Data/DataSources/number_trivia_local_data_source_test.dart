import 'dart:convert';

import 'package:clean_architecture/Core/Error/exceptions.dart';
import 'package:clean_architecture/Features/NumberTrivia/Data/DataSources/number_trivia_local_data_source.dart';
import 'package:clean_architecture/Features/NumberTrivia/Data/Models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late NumberTriviaLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group("getLastNumberTrivia", () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cache.json')));
    test(
        'should get NumberTrivia from SharedPrefrence when there is one cached',
        () async {
      //arrange
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(fixture('trivia_cache.json'));
      //act
      final result = await dataSource.getLastNumberTrivia();
      //assert
      verify(() => mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA))
          .called(1);
      expect(result, tNumberTriviaModel);
    });
    test('should throw CacheExceptions when there is not a cached value',
        () async {
      //arrange
      when(() => mockSharedPreferences.getString(any())).thenReturn(null);
      //act
      final call = dataSource.getLastNumberTrivia;
      //assert
      expect(() => call(), throwsA(const TypeMatcher<CacheExceptions>()));
      verify(() => mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA))
          .called(1);
    });
  });
  group("getLastNumberTrivia", () {
    const tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'test text');

    test('should call SharedPrefrences to cache the data', () async {
      //arange
      when(() => mockSharedPreferences.setString(any(), any()))
          .thenAnswer((_) async => true);

      //act
      dataSource.cacheNumberTrivia(tNumberTriviaModel);
      //assert
      final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
      verify(() => mockSharedPreferences.setString(
          CACHED_NUMBER_TRIVIA, expectedJsonString)).called(1);
    });
  });
}
