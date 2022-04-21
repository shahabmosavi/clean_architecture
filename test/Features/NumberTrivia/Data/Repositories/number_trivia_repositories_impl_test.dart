import 'package:clean_architecture/Core/Error/exceptions.dart';
import 'package:clean_architecture/Core/Error/faliure.dart';
import 'package:clean_architecture/Core/Network/network_info.dart';
import 'package:clean_architecture/Features/NumberTrivia/Data/DataSources/number_trivia_local_data_source.dart';
import 'package:clean_architecture/Features/NumberTrivia/Data/DataSources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture/Features/NumberTrivia/Data/Models/number_trivia_model.dart';
import 'package:clean_architecture/Features/NumberTrivia/Data/Repositories/number_trivia_repository_impl.dart';
import 'package:clean_architecture/Features/NumberTrivia/Domain/Entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late MockLocalDataSource mockLocalDataSource;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late NumberTriviaRepositoryImpl repository;

  setUp(() {
    mockLocalDataSource = MockLocalDataSource();
    mockRemoteDataSource = MockRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
        localDataSource: mockLocalDataSource,
        remoteDataSource: mockRemoteDataSource,
        networkInfo: mockNetworkInfo);
  });
  const int tNumber = 1;
  const String tText = 'test text';
  const NumberTriviaModel tNumberTriviaModel =
      NumberTriviaModel(number: tNumber, text: tText);
  const NumberTrivia tNumberTrivia = tNumberTriviaModel;

  group("getConcreteNumberTrivia", () {
    test('should check if device is online', () async {
      //arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
          .thenAnswer((_) async => tNumberTriviaModel);
      //act
      await repository.getConcreteNumberTrivia(tNumber);
      //assert
      verify(() => mockNetworkInfo.isConnected);
    });
    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        //arrange
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        //assert
        expect(result, const Right(tNumberTrivia));
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
      });
      test(
          'should cache locally data when the call to remote data source is successful',
          () async {
        //arrange
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        await repository.getConcreteNumberTrivia(tNumber);
        //assert
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));

        verify(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });
      test(
          'should retrun server failure when the call to remote data source is unsuccessful',
          () async {
        //arrange
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
            .thenThrow(ServerExceptions());
        //act
        final result = await repository.getConcreteNumberTrivia(tNumber);

        //assert
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, Left(ServerFailure()));

        verifyZeroInteractions(mockLocalDataSource);
      });
    });

    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      test(
          'should return last locally cached data when the cached data is present',
          () async {
        //arrange
        when(() => mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getLastNumberTrivia());
        expect(result, const Right(tNumberTrivia));
      });
      test('should return CacheFailure when there is no cached data present',
          () async {
        //arrange
        when(() => mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheExceptions());
        //act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getLastNumberTrivia());
        expect(result, Left(CacheFailure()));
      });
    });
  });

  group("getRandomNumberTrivia", () {
    test('should check if device is online', () async {
      //arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getRandomNumberTrivia())
          .thenAnswer((_) async => tNumberTriviaModel);
      //act
      await repository.getRandomNumberTrivia();
      //assert
      verify(() => mockNetworkInfo.isConnected);
    });
    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        //arrange
        when(() => mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final result = await repository.getRandomNumberTrivia();
        //assert
        expect(result, const Right(tNumberTrivia));
        verify(() => mockRemoteDataSource.getRandomNumberTrivia());
      });
      test(
          'should cache locally data when the call to remote data source is successful',
          () async {
        //arrange
        when(() => mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        await repository.getRandomNumberTrivia();
        //assert
        verify(() => mockRemoteDataSource.getRandomNumberTrivia());

        verify(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });
      test(
          'should retrun server failure when the call to remote data source is unsuccessful',
          () async {
        //arrange
        when(() => mockRemoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerExceptions());
        //act
        final result = await repository.getRandomNumberTrivia();

        //assert
        verify(() => mockRemoteDataSource.getRandomNumberTrivia());
        expect(result, Left(ServerFailure()));

        verifyZeroInteractions(mockLocalDataSource);
      });
    });

    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      test(
          'should return last locally cached data when the cached data is present',
          () async {
        //arrange
        when(() => mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final result = await repository.getRandomNumberTrivia();
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getLastNumberTrivia());
        expect(result, const Right(tNumberTrivia));
      });
      test('should return CacheFailure when there is no cached data present',
          () async {
        //arrange
        when(() => mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheExceptions());
        //act
        final result = await repository.getRandomNumberTrivia();
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getLastNumberTrivia());
        expect(result, Left(CacheFailure()));
      });
    });
  });
}
