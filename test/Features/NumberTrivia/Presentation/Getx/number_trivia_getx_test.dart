import 'package:clean_architecture/Core/Error/faliure.dart';
import 'package:clean_architecture/Core/Usecases/usecase.dart';
import 'package:clean_architecture/Core/Utils/input_converter.dart';
import 'package:clean_architecture/Features/NumberTrivia/Domain/Entities/number_trivia.dart';
import 'package:clean_architecture/Features/NumberTrivia/Domain/Usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture/Features/NumberTrivia/Domain/Usecases/get_random_number_trivia.dart';
import 'package:clean_architecture/Features/NumberTrivia/Presentation/getx/number_trivia_getx.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;
  late NumberTriviaGetx getx;
  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    registerFallbackValue(const Params(number: 10));
    registerFallbackValue(const NoParams());
    getx = NumberTriviaGetx(
        concrete: mockGetConcreteNumberTrivia,
        random: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test('state should be empty  ', () async {
    //assert
    expect(getx.state, NumberTriviaStates.Empty);
  });
  group('getTriviaForConcreteNumber', () {
    String tNumberString = '1';
    int tNumberParsed = 1;
    const tNumberTrivia = NumberTrivia(number: 1, text: 'test text');
    test('should get concrete for number when input is valid', () async {
      //arrange
      when(
        () => mockInputConverter.stringToUnSignedInteger(any()),
      ).thenReturn(Right(tNumberParsed));
      when(() => mockGetConcreteNumberTrivia(any()))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      //act
      await getx.getTriviaForConcreteNumber(tNumberString);
      //assert
      verify(() => mockInputConverter.stringToUnSignedInteger(tNumberString));
      verify(() => mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
      expect(getx.trivia, tNumberTrivia);
    });
    test(
        'should change state to error if input is invalid and set message error',
        () async {
      //arrange
      when(
        () => mockInputConverter.stringToUnSignedInteger(any()),
      ).thenReturn(Left(InvalidInputFailure()));

      //act
      getx.getTriviaForConcreteNumber(tNumberString);
      //assert
      expect(getx.message, InvalidInputFailure().message());
      verify(() => mockInputConverter.stringToUnSignedInteger(tNumberString));
      verifyZeroInteractions(mockGetConcreteNumberTrivia);
    });
    test(
        'should fire states [Loading,Loaded] in oreder when data gotten successfully',
        () async {
      //arrange
      when(
        () => mockInputConverter.stringToUnSignedInteger(any()),
      ).thenReturn(Right(tNumberParsed));
      when(() => mockGetConcreteNumberTrivia(any()))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      //act
      final future = getx.getTriviaForConcreteNumber(tNumberString);
      expect(getx.state, NumberTriviaStates.Loading);
      await future;
      expect(getx.state, NumberTriviaStates.Loaded);
    });
    test(
        'should change state to error when getting data is failed and set error message',
        () async {
      //arrange
      when(
        () => mockInputConverter.stringToUnSignedInteger(any()),
      ).thenReturn(Right(tNumberParsed));
      when(() => mockGetConcreteNumberTrivia(any()))
          .thenAnswer((_) async => Left(ServerFailure()));
      //act
      await getx.getTriviaForConcreteNumber(tNumberString);
      //expect
      expect(getx.state, NumberTriviaStates.Error);
      expect(getx.message, ServerFailure().message());
    });
    test(
        'should change state to error when getting data is failed and set proper error message',
        () async {
      //arrange
      when(
        () => mockInputConverter.stringToUnSignedInteger(any()),
      ).thenReturn(Right(tNumberParsed));
      when(() => mockGetConcreteNumberTrivia(any()))
          .thenAnswer((_) async => Left(CacheFailure()));
      //act
      await getx.getTriviaForConcreteNumber(tNumberString);
      //expect
      expect(getx.state, NumberTriviaStates.Error);
      expect(getx.message, CacheFailure().message());
    });
  });

  group('getTriviaForRandomNumber', () {
    const tNumberTrivia = NumberTrivia(number: 1, text: 'test text');
    test(
        'should fire states [Loading,Loaded] in oreder when data gotten successfully',
        () async {
      //arrange

      when(() => mockGetRandomNumberTrivia(any()))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      //act
      final future = getx.getTriviaForRandomNumber();
      expect(getx.state, NumberTriviaStates.Loading);
      await future;
      expect(getx.state, NumberTriviaStates.Loaded);
    });
    test(
        'should change state to error when getting data is failed and set error message',
        () async {
      //arrange

      when(() => mockGetRandomNumberTrivia(any()))
          .thenAnswer((_) async => Left(ServerFailure()));
      //act
      await getx.getTriviaForRandomNumber();
      //expect
      expect(getx.state, NumberTriviaStates.Error);
      expect(getx.message, ServerFailure().message());
    });
    test(
        'should change state to error when getting data is failed and set proper error message',
        () async {
      //arrange

      when(() => mockGetRandomNumberTrivia(any()))
          .thenAnswer((_) async => Left(CacheFailure()));
      //act
      await getx.getTriviaForRandomNumber();
      //expect
      expect(getx.state, NumberTriviaStates.Error);
      expect(getx.message, CacheFailure().message());
    });
  });
}
