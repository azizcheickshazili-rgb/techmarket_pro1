import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techmarket_pro1/core/storage/secure_storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Map<String, String> backingStore;
  late SecureStorageService service;

  setUp(() {
    backingStore = <String, String>{};

    const MethodChannel channel = MethodChannel(
      'plugins.it_nomads.com/flutter_secure_storage',
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall call) async {
      switch (call.method) {
        case 'write':
          final Map<dynamic, dynamic> args = call.arguments as Map<dynamic, dynamic>;
          backingStore[args['key'] as String] = args['value'] as String;
          return null;
        case 'read':
          final Map<dynamic, dynamic> args = call.arguments as Map<dynamic, dynamic>;
          return backingStore[args['key'] as String];
        case 'delete':
          final Map<dynamic, dynamic> args = call.arguments as Map<dynamic, dynamic>;
          backingStore.remove(args['key'] as String);
          return null;
        case 'readAll':
          return backingStore;
        case 'deleteAll':
          backingStore.clear();
          return null;
        default:
          return null;
      }
    });

    service = SecureStorageService(storage: const FlutterSecureStorage());
  });

  group('SecureStorageService', () {
    test('hasValidSession is false when nothing was saved', () async {
      expect(await service.hasValidSession(), isFalse);
    });

    test('saveTokens then readAccessToken returns the saved token', () async {
      await service.saveTokens(accessToken: 'access123', refreshToken: 'refresh456');
      expect(await service.readAccessToken(), 'access123');
      expect(await service.readRefreshToken(), 'refresh456');
    });

    test('hasValidSession is true after tokens are saved', () async {
      await service.saveTokens(accessToken: 'access123', refreshToken: 'refresh456');
      expect(await service.hasValidSession(), isTrue);
    });

    test('clear removes both tokens', () async {
      await service.saveTokens(accessToken: 'a', refreshToken: 'b');
      await service.clear();
      expect(await service.readAccessToken(), isNull);
      expect(await service.hasValidSession(), isFalse);
    });
  });
}
