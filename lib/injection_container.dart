import 'package:clean_architecture/Features/NumberTrivia/Presentation/getx/number_trivia_getx.dart';
import 'package:get/get.dart';

import 'Core/Network/network_info.dart';
import 'Core/Utils/input_converter.dart';
import 'Features/NumberTrivia/Data/DataSources/number_trivia_local_data_source.dart';
import 'Features/NumberTrivia/Data/DataSources/number_trivia_remote_data_source.dart';
import 'Features/NumberTrivia/Data/Repositories/number_trivia_repository_impl.dart';
import 'Features/NumberTrivia/Domain/Repositories/number_trivia_repository.dart';
import 'Features/NumberTrivia/Domain/Usecases/get_concrete_number_trivia.dart';
import 'Features/NumberTrivia/Domain/Usecases/get_random_number_trivia.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<void> init() async {
  Get.lazyPut(() => http.Client());
  Get.lazyPut(() => InternetConnectionChecker());
  await Get.putAsync(() => SharedPreferences.getInstance());
  Get.lazyPut<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(
        sharedPreferences: Get.find<SharedPreferences>()),
  );
  Get.lazyPut<NetworkInfo>(() => NetworkInfoImpl(Get.find()));
  Get.lazyPut<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(client: Get.find()),
  );
  Get.lazyPut<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      localDataSource: Get.find(),
      networkInfo: Get.find(),
      remoteDataSource: Get.find(),
    ),
  );
  // Use cases
  Get.lazyPut(() => GetConcreteNumberTrivia(Get.find()));
  Get.lazyPut(() => GetRandomNumberTrivia(Get.find()));
  //! Features - Number Trivia
  // Bloc
  Get.lazyPut(() => InputConverter());

  Get.lazyPut(
    () => NumberTriviaGetx(
      concrete: Get.find(),
      inputConverter: Get.find(),
      random: Get.find(),
    ),
  );

  // Data sources

  //! Core

  // Repository

  //! External
}
