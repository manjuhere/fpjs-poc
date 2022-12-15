class EnvironmentConfig {
  static const String envDev = 'dev';
  static const String envProd = 'prod';
  static late EnvironmentConfig _config;

  static final EnvironmentConfig _dev = EnvironmentConfig(
    appName: 'Uni Dev',
    env: envDev,
    sentryDns: '',
    fingerprintJsApiKey: '',
  );

  static final EnvironmentConfig _prod = EnvironmentConfig(
    appName: 'Uni',
    env: envProd,
    sentryDns: '',
    fingerprintJsApiKey: '',
  );

  final String appName;
  final String env;
  final String sentryDns;
  final String fingerprintJsApiKey;

  EnvironmentConfig({
    required this.appName,
    required this.env,
    required this.sentryDns,
    required this.fingerprintJsApiKey,
  });

  static EnvironmentConfig getConfig() {
    return _config;
  }

  static void initConfig(String env, {String? baseUrl}) {
    switch (env) {
      case envDev:
        _config = _dev;
        break;
      case envProd:
        _config = _prod;
        break;
      default:
        throw UnsupportedError('$env environment is not available');
    }
  }

  static bool isProdApp() {
    return _config.env == envProd;
  }

  static bool isDebuggable() {
    return _config.env == EnvironmentConfig.envDev;
  }
}
