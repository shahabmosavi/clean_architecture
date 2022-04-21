import 'package:clean_architecture/Core/Network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';

class MockDataConnectionChecker extends Mock
    implements InternetConnectionChecker {}

void main() {
  late MockDataConnectionChecker mockDataConnectionChecker;
  late NetworkInfoImpl networkInfoImpl;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockDataConnectionChecker);
  });

  group('isConnected', () {
    test('should forward the call to DataConnectionChecker.hasConnection',
        () async {
      //arrange
      final tHasConnection = Future.value(true);
      when(() => mockDataConnectionChecker.hasConnection)
          .thenAnswer((_) async => tHasConnection);
      //act
      networkInfoImpl.isConnected;
      //assert
      verify(() => mockDataConnectionChecker.hasConnection).called(1);
    });
  });
}
