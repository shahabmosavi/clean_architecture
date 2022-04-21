import 'package:clean_architecture/Features/NumberTrivia/Domain/Entities/number_trivia.dart';
import 'package:clean_architecture/Features/NumberTrivia/Domain/Repositories/number_trivia_repository.dart';
import 'package:clean_architecture/Features/NumberTrivia/Domain/Usecases/get_concrete_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNumberConcreteRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  late GetConcreteNumberTrivia usecase;
  late MockNumberConcreteRepository mockNumberConcreteRepository;

  setUp(() {
    mockNumberConcreteRepository = MockNumberConcreteRepository();
    usecase = GetConcreteNumberTrivia(mockNumberConcreteRepository);
  });

  const int tNumber = 1;
  const NumberTrivia tNumberTrivia =
      NumberTrivia(number: tNumber, text: "test");
  test('should get trivia for the number from repository', () async {
    //arrange
    when(() => mockNumberConcreteRepository.getConcreteNumberTrivia(tNumber))
        .thenAnswer((realInvocation) async => const Right(tNumberTrivia));
    //act
    final result = await usecase(const Params(number: tNumber));
    //assert
    expect(result, const Right(tNumberTrivia));
    verify(() => mockNumberConcreteRepository.getConcreteNumberTrivia(tNumber));
    verifyNoMoreInteractions(mockNumberConcreteRepository);
  });
}
