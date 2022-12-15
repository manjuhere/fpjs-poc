import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

var sharedPreferencesServiceProvider = Provider<SharedPreferenceService>((_) => throw UnimplementedError());

class SharedPreferenceService {
  final SharedPreferences _sharedPreferences;

  static const String fingerprintJsId = 'fingerprintJsId';
  static const String fingerprintJsIdLastFetch = 'fingerprintJsIdLastFetch';

  SharedPreferenceService(this._sharedPreferences);

  Future<bool> setFingerprintJsId(String visitorId) async {
    return await _sharedPreferences.setString(fingerprintJsId, visitorId);
  }

  String? getFingerprintJsId() {
    return _sharedPreferences.getString(fingerprintJsId);
  }

  /// set last fetched time since epoch in milliseconds
  Future<bool> setLastFingerprintJsIdFetch(int milliSinceEpoch) async {
    return await _sharedPreferences.setInt(fingerprintJsIdLastFetch, milliSinceEpoch);
  }

  /// fetches last fetched time since epoch in milliseconds
  int? getLastFingerprintJsIdFetch() {
    return _sharedPreferences.getInt(fingerprintJsIdLastFetch);
  }

  Future<void> clearData() async {
    await _sharedPreferences.clear();
  }
}
