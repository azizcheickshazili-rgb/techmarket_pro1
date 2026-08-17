import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_constants.dart';
import 'core_providers.dart';

class LocaleController extends StateNotifier<Locale> {
  LocaleController(this._ref) : super(_readInitialLocale(_ref));

  final Ref _ref;

  static Locale _readInitialLocale(Ref ref) {
    final String? saved =
        ref.read(sharedPreferencesProvider).getString(AppConstants.localeKey);
    return Locale(saved ?? 'fr');
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    await _ref
        .read(sharedPreferencesProvider)
        .setString(AppConstants.localeKey, locale.languageCode);
  }
}

final StateNotifierProvider<LocaleController, Locale> localeControllerProvider =
    StateNotifierProvider<LocaleController, Locale>(
  (Ref ref) => LocaleController(ref),
);
