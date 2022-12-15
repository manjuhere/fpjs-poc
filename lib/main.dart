import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpjs_poc/poc/app_initializers.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'poc/environment_config.dart';
import 'poc/my_app.dart';
import 'poc/shared_preference_service.dart';

Future<void> main() async {
  EnvironmentConfig.initConfig('dev');

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  final sharedPreferences = await SharedPreferences.getInstance();
  final container = ProviderContainer(overrides: [
    sharedPreferencesServiceProvider.overrideWithValue(SharedPreferenceService(sharedPreferences)),
  ]);
  await App.initialize(container);
  Paint.enableDithering = true;

  await SentryFlutter.init(
    (options) => {
      options.dsn = 'https://4c2b6d087b4f4fa48ee248d154add01e@o493807.ingest.sentry.io/5657806',
    },
    appRunner: () => runApp(
      UncontrolledProviderScope(
        container: container,
        child: const MyApp(),
      ),
    ),
  );
}
