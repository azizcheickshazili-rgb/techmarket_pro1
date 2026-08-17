import 'package:flutter_test/flutter_test.dart';
import 'package:techmarket/core/utils/result.dart';

void main() {
  group('Result', () {
    test('Ok exposes isOk true and isErr false', () {
      const Result<int> result = Result<int>.ok(42);
      expect(result.isOk, isTrue);
      expect(result.isErr, isFalse);
    });

    test('Err exposes isErr true and isOk false', () {
      const Result<int> result = Result<int>.err(NetworkFailure());
      expect(result.isErr, isTrue);
      expect(result.isOk, isFalse);
    });

    test('when() calls the ok branch with the wrapped value', () {
      const Result<String> result = Result<String>.ok('hello');
      final String output = result.when(
        ok: (String value) => 'ok:$value',
        err: (Failure failure) => 'err:${failure.message}',
      );
      expect(output, 'ok:hello');
    });

    test('when() calls the err branch with the wrapped failure', () {
      const Result<String> result = Result<String>.err(AuthFailure('bad creds'));
      final String output = result.when(
        ok: (String value) => 'ok:$value',
        err: (Failure failure) => 'err:${failure.message}',
      );
      expect(output, 'err:bad creds');
    });

    test('Failures with identical messages are equal (Equatable)', () {
      expect(const ServerFailure('boom', statusCode: 500),
          const ServerFailure('boom', statusCode: 500));
      expect(const ServerFailure('boom', statusCode: 500) == const ServerFailure('boom', statusCode: 404),
          isFalse);
    });
  });
}
