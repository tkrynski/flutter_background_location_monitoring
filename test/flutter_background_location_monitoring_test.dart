import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_background_location_monitoring/flutter_background_location_monitoring.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_background_location_monitoring');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FlutterBackgroundLocationMonitoring.platformVersion, '42');
  });
}
