import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  static const String routeName = 'profile';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final AuthState authState = ref.watch(authControllerProvider);
    final Locale currentLocale = ref.watch(localeControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          if (authState is AuthAuthenticated) ...<Widget>[
            Center(
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: AppColors.navySurfaceElevated,
                    backgroundImage: authState.user.image != null
                        ? CachedNetworkImageProvider(authState.user.image!)
                        : null,
                    child: authState.user.image == null
                        ? const Icon(Icons.person_rounded, size: 40)
                        : null,
                  ),
                  const SizedBox(height: 14),
                  Text(authState.user.fullName,
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 2),
                  Text('@${authState.user.username}',
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
          Text(l10n.languageLabel, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: const <ButtonSegment<String>>[
              ButtonSegment<String>(value: 'fr', label: Text('Français')),
              ButtonSegment<String>(value: 'en', label: Text('English')),
            ],
            selected: <String>{currentLocale.languageCode},
            onSelectionChanged: (Set<String> selection) {
              ref
                  .read(localeControllerProvider.notifier)
                  .setLocale(Locale(selection.first));
            },
          ),
          const SizedBox(height: 32),
          Semantics(
            button: true,
            label: l10n.logoutButton,
            child: OutlinedButton.icon(
              key: const Key('logout_button'),
              onPressed: () => ref.read(authControllerProvider.notifier).logout(),
              icon: const Icon(Icons.logout_rounded, color: AppColors.danger),
              label: Text(
                l10n.logoutButton,
                style: const TextStyle(color: AppColors.danger),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
