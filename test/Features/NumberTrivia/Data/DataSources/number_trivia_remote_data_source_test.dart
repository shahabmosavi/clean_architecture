import 'dart:convert';

import 'package:clean_architecture/Core/Error/exceptions.dart';
import 'package:clean_architecture/Features/NumberTrivia/Data/DataSources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture/Features/NumberTrivia/Data/Models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

import '../../../../Fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MockHttpClient mockHttpClient;
  late NumberTriviaRemoteDataSourceImpl dataSource;
  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(() => mockHttpClient.get(any(), headers: any(named: "headers")))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFaliure404() {
    when(() => mockHttpClient.get(any(), headers: any(named: "headers")))
        .thenAnswer((_) async => http.Response("some thing went wrong", 404));
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    setUp(() {
      registerFallbackValue(Uri());
    });
    test('''should perform a GET request on a URL with number
         being in the endpoint and with application/json header''', () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      dataSource.getConcreteNumberTrivia(tNumber);
      //assert
      verify(() => mockHttpClient.get(
          Uri.parse('http://numbersapi.com/$tNumber'),
          headers: {'Content-Type': 'application/json'}));
    });
    test('should return a NumberTrivia when response code is 200 (success)',
        () async {
      //arrange
      setUpMockHttpClientSuccess200();

      //act
      final result = await dataSource.getConcreteNumberTrivia(tNumber);

      //assert
      expect(result, tNumberTriviaModel);
    });
    test('should throw a ServerExceptions when response code is 404 or others',
        () async {
      //arrange
      setUpMockHttpClientFaliure404();
      //act
      final call = dataSource.getConcreteNumberTrivia;

      //assert
      expect(
          () => call(tNumber), throwsA(const TypeMatcher<ServerExceptions>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    setUp(() {
      registerFallbackValue(Uri());
    });
    test('''should perform a GET request on a URL with number
         being in the endpoint and with application/json header''', () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      dataSource.getRandomNumberTrivia();
      //assert
      verify(() => mockHttpClient.get(Uri.parse('http://numbersapi.com/random'),
          headers: {'Content-Type': 'application/json'}));
    });
    test('should return a NumberTrivia when response code is 200 (success)',
        () async {
      //arrange
      setUpMockHttpClientSuccess200();

      //act
      final result = await dataSource.getRandomNumberTrivia();

      //assert
      expect(result, tNumberTriviaModel);
    });
    test('should throw a ServerExceptions when response code is 404 or others',
        () async {
      //arrange
      setUpMockHttpClientFaliure404();
      //act
      final call = dataSource.getRandomNumberTrivia;

      //assert
      expect(() => call(), throwsA(const TypeMatcher<ServerExceptions>()));
    });
  });
}
