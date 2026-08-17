import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Centralised loading spinner so every screen renders the same busy
/// state, wrapped with a semantic label for screen readers.
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key, this.label = 'Chargement en cours'});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      liveRegion: true,
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColors.cyanAccent,
          strokeWidth: 2.6,
        ),
      ),
    );
  }
}
