import 'package:clean_architecture/Core/Usecases/usecase.dart';
import 'package:clean_architecture/Features/NumberTrivia/Domain/Entities/number_trivia.dart';
import 'package:clean_architecture/Features/NumberTrivia/Domain/Repositories/number_trivia_repository.dart';
import 'package:clean_architecture/Features/NumberTrivia/Domain/Usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNumberConcreteRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  late GetRandomNumberTrivia usecase;
  late MockNumberConcreteRepository mockNumberConcreteRepository;

  setUp(() {
    mockNumberConcreteRepository = MockNumberConcreteRepository();
    usecase = GetRandomNumberTrivia(mockNumberConcreteRepository);
  });

  const NumberTrivia tNumberTrivia = NumberTrivia(number: 1, text: "test");
  test('should get trivia from repository', () async {
    //arrange
    when(() => mockNumberConcreteRepository.getRandomNumberTrivia())
        .thenAnswer((realInvocation) async => const Right(tNumberTrivia));
    //act
    final result = await usecase(const NoParams());
    //assert
    expect(result, const Right(tNumberTrivia));
    verify(() => mockNumberConcreteRepository.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockNumberConcreteRepository);
  });
}
