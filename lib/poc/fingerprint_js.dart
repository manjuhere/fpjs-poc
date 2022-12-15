// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpjs_pro_plugin/fpjs_pro_plugin.dart';
import 'package:fpjs_pro_plugin/region.dart';

import 'extensions.dart';
import 'environment_config.dart';
import 'shared_preference_service.dart';

final fingerprintJsProvider = Provider<FingerprintJs>((ref) {
  SharedPreferenceService sharedPrefsService = ref.watch(sharedPreferencesServiceProvider);
  return FingerprintJs(sharedPrefsService);
});

class FingerprintJs {
  static const DEFAULT_FINGERPRINT_CACHE_INTERVAL_MS = 86400000; // default of 1 day
  static const _tag = 'FingerprintJs:';

  final SharedPreferenceService _sharedPrefsService;
  const FingerprintJs(this._sharedPrefsService);

  Future<void> init() async {
    final String apiKey = EnvironmentConfig.getConfig().fingerprintJsApiKey;
    assert(apiKey.isNotNullAndNotEmpty);
    try {
      await FpjsProPlugin.initFpjs(apiKey, region: Region.ap);
    } catch (e) {
      debugPrint('$_tag Exception caused while initialising fingerprint - $e');
    }
  }

  Future<String?> getFingerPrintId() async {
    if (_shouldMakeFreshCall) {
      try {
        String? visitorId = await FpjsProPlugin.getVisitorId();
        debugPrint('$_tag Making Fresh Call - $visitorId');
        await _sharedPrefsService.setLastFingerprintJsIdFetch(DateTime.now().millisecondsSinceEpoch);
        return visitorId;
      } catch (e) {
        debugPrint('$_tag Exception caused while fetching fingerprint - $e');
        debugPrint('$_tag Exception: Fetching from cache - ${_sharedPrefsService.getFingerprintJsId()}');
        return _sharedPrefsService.getFingerprintJsId();
      }
    } else {
      debugPrint('$_tag Fetching from cache - ${_sharedPrefsService.getFingerprintJsId()}');
      return _sharedPrefsService.getFingerprintJsId();
    }
  }

  bool get _shouldMakeFreshCall {
    int cacheInterval = DEFAULT_FINGERPRINT_CACHE_INTERVAL_MS; // can be controlled from backend during app launch
    int? lastFetchedTime = _sharedPrefsService.getLastFingerprintJsIdFetch();
    // if last fetched time is null
    if (lastFetchedTime == null) {
      return true;
    }
    // if no ID is available in cache
    if (getCachedFingerprintJsId().isNullOrEmpty) {
      return true;
    }
    // if last fetched + duration < current time stamp then make fresh call
    return lastFetchedTime + cacheInterval < DateTime.now().millisecondsSinceEpoch;
  }

  Future<bool> cacheFingerprintJsId(String? visitorId) async {
    if (visitorId.isNotNullAndNotEmpty) {
      return await _sharedPrefsService.setFingerprintJsId(visitorId!);
    } else {
      debugPrint('$_tag Exception caused while saving fingerprint.');
      return false;
    }
  }

  String? getCachedFingerprintJsId() {
    return _sharedPrefsService.getFingerprintJsId();
  }
}
