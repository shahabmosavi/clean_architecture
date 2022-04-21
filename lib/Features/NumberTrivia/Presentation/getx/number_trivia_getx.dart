// ignore_for_file: constant_identifier_names

import 'package:clean_architecture/Core/Usecases/usecase.dart';
import 'package:clean_architecture/Core/Utils/input_converter.dart';
import 'package:clean_architecture/Features/NumberTrivia/Domain/Entities/number_trivia.dart';
import 'package:clean_architecture/Features/NumberTrivia/Domain/Usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture/Features/NumberTrivia/Domain/Usecases/get_random_number_trivia.dart';
import 'package:get/get.dart';

class NumberTriviaGetx extends GetxController {
  final GetConcreteNumberTrivia concrete;
  final GetRandomNumberTrivia random;
  final InputConverter inputConverter;
  final Rx<NumberTriviaStates> _state = NumberTriviaStates.Empty.obs;
  final RxString _message = 'Start Searching!'.obs;
  final Rx<NumberTrivia> _trivia =
      const NumberTrivia(number: 1, text: 'text').obs;

  NumberTriviaGetx(
      {required this.concrete,
      required this.random,
      required this.inputConverter});
  NumberTriviaStates get state => _state.value;
  NumberTrivia get trivia => _trivia.value;
  String get message => _message.value;
  set state(NumberTriviaStates val) {
    _state.value = val;
  }

  set message(String val) {
    _message.value = val;
  }

  set trivia(NumberTrivia val) {
    _trivia.value = val;
  }

  Future<void> getTriviaForConcreteNumber(String numberString) async {
    state = NumberTriviaStates.Empty;
    final numberOrFailure =
        inputConverter.stringToUnSignedInteger(numberString);
    numberOrFailure.fold((failure) {
      state = NumberTriviaStates.Error;
      message = failure.message();
    }, (number) async {
      await _getTrivia(concrete, Params(number: number));
    });
  }

  Future<void> getTriviaForRandomNumber() async {
    await _getTrivia(random, const NoParams());
  }

  Future<void> _getTrivia(usecase, params) async {
    state = NumberTriviaStates.Empty;
    state = NumberTriviaStates.Loading;
    final failureOrTrivia = await usecase(params);
    failureOrTrivia.fold((failure) {
      state = NumberTriviaStates.Error;
      message = failure.message();
    }, (mytr) {
      trivia = mytr;
      state = NumberTriviaStates.Loaded;
    });
  }
}

enum NumberTriviaStates {
  Empty,
  Loading,
  Loaded,
  Error,
}
