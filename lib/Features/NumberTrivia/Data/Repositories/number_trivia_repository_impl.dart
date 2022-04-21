import 'package:dartz/dartz.dart';

import '../../../../Core/Error/exceptions.dart';
import '../../../../Core/Error/faliure.dart';
import '../../../../Core/Network/network_info.dart';
import '../../Domain/Entities/number_trivia.dart';
import '../../Domain/Repositories/number_trivia_repository.dart';
import '../DataSources/number_trivia_local_data_source.dart';
import '../DataSources/number_trivia_remote_data_source.dart';
import '../Models/number_trivia_model.dart';

class NumberTriviaRepositoryImpl extends NumberTriviaRepository {
  final NumberTriviaLocalDataSource localDataSource;
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl(
      {required this.localDataSource,
      required this.remoteDataSource,
      required this.networkInfo});
  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return _getTrivia(() => remoteDataSource.getConcreteNumberTrivia(number))!;
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return _getTrivia(() => remoteDataSource.getRandomNumberTrivia())!;
  }

  Future<Either<Failure, NumberTrivia>>? _getTrivia(
      Future<NumberTriviaModel>? Function() getRandomOrConcrete) async {
    if (await networkInfo.isConnected!) {
      try {
        final NumberTriviaModel triviaToCache = await getRandomOrConcrete()!;
        localDataSource.cacheNumberTrivia(triviaToCache);
        return Right(triviaToCache);
      } on ServerExceptions {
        return Left(ServerFailure());
      }
    } else {
      try {
        final NumberTrivia localTrivia =
            await localDataSource.getLastNumberTrivia()!;

        return Right(localTrivia);
      } on CacheExceptions {
        return Left(CacheFailure());
      }
    }
  }
}
