import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class SplashScreen extends HookConsumerWidget {
  const SplashScreen({super.key});

  static const String routeName = 'splash';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      Future<void>.microtask(() async {
        final Stopwatch stopwatch = Stopwatch()..start();
        await ref.read(authControllerProvider.notifier).restoreSession();
        final int elapsed = stopwatch.elapsedMilliseconds;
        final int remaining =
            AppConstants.splashMinDuration.inMilliseconds - elapsed;
        if (remaining > 0) {
          await Future<void>.delayed(Duration(milliseconds: remaining));
        }
      });
      return null;
    }, const <Object?>[]);

    return const Scaffold(
      body: Center(
        child: Semantics(
          label: 'TechMarket, chargement de l\'application',
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.storefront_rounded, color: AppColors.cyanAccent, size: 56),
              SizedBox(height: 16),
              Text(
                'TechMarket',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
