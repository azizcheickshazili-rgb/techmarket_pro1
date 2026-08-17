import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Generic full-area error state with an optional retry callback.
/// Reused by every screen instead of ad-hoc error widgets, so failures
/// look and behave consistently across the app.
class ErrorView extends StatelessWidget {
  const ErrorView({
    required this.message,
    super.key,
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.wifi_off_rounded,
              color: AppColors.textSecondary,
              size: 42,
            ),
            const SizedBox(height: 12),
            Semantics(
              liveRegion: true,
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            if (onRetry != null) ...<Widget>[
              const SizedBox(height: 16),
              Semantics(
                button: true,
                label: 'Réessayer',
                child: OutlinedButton(
                  onPressed: onRetry,
                  child: const Text('Réessayer'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
