import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpjs_poc/poc/fingerprint_js.dart';

class App {
  /// Calls all initializers that need to await and execute synchronously and get executed in background
  static Future<void> initialize(ProviderContainer ref) async {
    // await ref.read(notificationServiceProvider).init();
    // await ref.read(sessionsServiceProvider).initSession();

    await _setupFingerprintJsId(ref);

    // ref.read(purgeServiceProvider).clearShareableStorage();
    // ref.read(moengageProvider).init();
    // await ref.read(deviceIdProvider).initializeDeviceId();
    // unawaited(ref.read(fcmProvider).init());
    // await ref.read(deviceInfoRepositoryProvider).init();
    // await ref.read(appsFlyerServiceProvider).init();
    // ref.read(appsFlyerServiceProvider).initUnifiedDeeplinkHandler(ref.read(deeplinksProvider));
  }

  static Future<void> _setupFingerprintJsId(ProviderContainer ref) async {
    FingerprintJs fingerprintJsService = ref.read(fingerprintJsProvider);
    await fingerprintJsService.init();
    String? visitorId = await fingerprintJsService.getFingerPrintId();
    unawaited(fingerprintJsService.cacheFingerprintJsId(visitorId));
  }
}
